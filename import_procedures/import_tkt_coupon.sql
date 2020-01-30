if OBJECT_ID('ImportTktCoupon', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportTktCoupon'
	drop procedure ImportTktCoupon
  END
GO

CREATE PROCEDURE dbo.ImportTktCoupon 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'TktCoupon' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_TktCoupon', 'U') is null
    BEGIN
	print 'Creating temp_TktCoupon'
		create table temp_TktCoupon(
      RecordIndicator NVARCHAR(1000),
      PNRLocatorID NVARCHAR(1000),
      PNRCreateDate NVARCHAR(1000),
      PrimaryDocNbr NVARCHAR(1000),
      VCRCreateDate NVARCHAR(1000),
      TranactionDateTime NVARCHAR(1000),
      CouponSeqNbr NVARCHAR(1000),
      EntNbr NVARCHAR(1000),
      CouponStatus NVARCHAR(1000),
      PreviousCouponStatusCode NVARCHAR(1000),
      SegmentTypeCode NVARCHAR(1000),
      MarketingAirlineCode NVARCHAR(1000),
      MarketingFlightNbr NVARCHAR(1000),
      ServiceStartCity NVARCHAR(1000),
      ServiceEndCity NVARCHAR(1000),
      SegmentStatusCode NVARCHAR(1000),
      ServiceStartDate NVARCHAR(1000),
      ServiceStartTime NVARCHAR(1000),
      ServiceEndDate NVARCHAR(1000),
      ServiceEndTime NVARCHAR(1000),
      ClassOfService NVARCHAR(1000),
      FareBasisCode NVARCHAR(1000),
      TktDsignatorCode NVARCHAR(1000),
      FareBreakInd NVARCHAR(1000),
      PriceNotValidBeforeDate NVARCHAR(1000),
      PriceNotValidAfterDate NVARCHAR(1000),
      InvoluntaryInd NVARCHAR(1000),
      FlownFlightNbr NVARCHAR(1000),
      FlownServiceStartDate NVARCHAR(1000),
      FlownServiceStartCity NVARCHAR(1000),
      FlownServiceEndCity NVARCHAR(1000),
      FlownClassOfService NVARCHAR(1000),
      FlownFlightOrigDate NVARCHAR(1000),
      OperatingAirlineCode NVARCHAR(1000),
      OperatingFlightNbr NVARCHAR(1000),
      OperatingPNRLocator NVARCHAR(1000),
      FareBreakAmt NVARCHAR(1000),
      FareBreakDiscAmt NVARCHAR(1000),
      DiscountAmtInd NVARCHAR(1000),
      DiscountPctInd NVARCHAR(1000),
      StopoverCode NVARCHAR(1000),
      FrequentTravelerNbr NVARCHAR(1000),
      VendorCode NVARCHAR(1000),
      FareBreakCurrencyCode NVARCHAR(1000),
      SettlementAuthCode NVARCHAR(1000),
      BaggageAlwncText NVARCHAR(1000)
		)
	  END

  PRINT 'Truncating temp_TktCoupon'
  TRUNCATE TABLE temp_TktCoupon

  set @bulk_insert_sql = 
    'BULK INSERT temp_TktCoupon FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''0x0a''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    PRINT char(13) + char(13)
    PRINT 'Amending rows to TktCoupon' + char(13)

    update TktCoupon
    set RecordIndicator = tktc.RecordIndicator,
        PNRLocatorID = tktc.PNRLocatorID,
        PNRCreateDate = tktc.PNRCreateDate,
        TranactionDateTime = tktc.TranactionDateTime,
        CouponSeqNbr = tktc.CouponSeqNbr,
        EntNbr = tktc.EntNbr,
        CouponStatus = tktc.CouponStatus,
        PreviousCouponStatusCode = tktc.PreviousCouponStatusCode,
        SegmentTypeCode = tktc.SegmentTypeCode,
        MarketingAirlineCode = tktc.MarketingAirlineCode,
        MarketingFlightNbr = tktc.MarketingFlightNbr,
        ServiceStartCity = tktc.ServiceStartCity,
        ServiceEndCity = tktc.ServiceEndCity,
        SegmentStatusCode = tktc.SegmentStatusCode,
        ServiceStartDate = tktc.ServiceStartDate,
        ServiceStartTime = tktc.ServiceStartTime,
        ServiceEndDate = tktc.ServiceEndDate,
        ServiceEndTime = tktc.ServiceEndTime,
        ClassOfService = tktc.ClassOfService,
        FareBasisCode = tktc.FareBasisCode,
        TktDsignatorCode = tktc.TktDsignatorCode,
        FareBreakInd = tktc.FareBreakInd,
        PriceNotValidBeforeDate = tktc.PriceNotValidBeforeDate,
        PriceNotValidAfterDate = tktc.PriceNotValidAfterDate,
        InvoluntaryInd = tktc.InvoluntaryInd,
        FlownFlightNbr = tktc.FlownFlightNbr,
        FlownServiceStartDate = tktc.FlownServiceStartDate,
        FlownServiceStartCity = tktc.FlownServiceStartCity,
        FlownServiceEndCity = tktc.FlownServiceEndCity,
        FlownClassOfService = tktc.FlownClassOfService,
        FlownFlightOrigDate = tktc.FlownFlightOrigDate,
        OperatingAirlineCode = tktc.OperatingAirlineCode,
        OperatingFlightNbr = tktc.OperatingFlightNbr,
        OperatingPNRLocator = tktc.OperatingPNRLocator,
        FareBreakAmt = tktc.FareBreakAmt,
        FareBreakDiscAmt = tktc.FareBreakDiscAmt,
        DiscountAmtInd = tktc.DiscountAmtInd,
        DiscountPctInd = tktc.DiscountPctInd,
        StopoverCode = tktc.StopoverCode,
        FrequentTravelerNbr = tktc.FrequentTravelerNbr,
        VendorCode = tktc.VendorCode,
        FareBreakCurrencyCode = tktc.FareBreakCurrencyCode,
        SettlementAuthCode = tktc.SettlementAuthCode,
        BaggageAlwncText = tktc.BaggageAlwncText
          
  from	TktCoupon tc
        inner join temp_TktCoupon tktc on tc.PrimaryDocNbr = tktc.PrimaryDocNbr and tc.VCRCreateDate = tktc.VCRCreateDate
        
        
    PRINT char(13) + char(13)
    PRINT 'Appending rows to TktCoupon' + char(13)
    
    insert TktCoupon
    select *
    from   temp_TktCoupon t1
    where  not exists (
      select 1
      from   TktCoupon _t1
      where _t1.PrimaryDocNbr = t1.PrimaryDocNbr and _t1.VCRCreateDate = t1.VCRCreateDate
    )
END;
GO

