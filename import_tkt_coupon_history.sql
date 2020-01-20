if OBJECT_ID('ImportTktCouponHistoryHistory', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportTktCouponHistoryHistory'
	drop procedure ImportTktCouponHistoryHistory
  END
GO

CREATE PROCEDURE dbo.ImportTktCouponHistoryHistory 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'TktCouponHistory' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_TktCouponHistory', 'U') is null
    BEGIN
	print 'Creating temp_TktCouponHistory'
		create table temp_TktCouponHistory(
      RecordIndicator NVARCHAR(1000),
      PNRLocatorID NVARCHAR(1000),
      PNRCreateDate NVARCHAR(1000),
      PrimaryDocNbr NVARCHAR(1000),
      VCRCreateDate NVARCHAR(1000),
      TransactionDateTime NVARCHAR(1000),
      CouponSeqNbr NVARCHAR(1000),
      FareBasisCode NVARCHAR(1000),
      CouponNbr NVARCHAR(1000),
      PreviousCouponStatusCode NVARCHAR(1000),
      NewCouponStatusCode NVARCHAR(1000),
      CouponNbrChanged NVARCHAR(1000),
      PreviousControlVendorCode NVARCHAR(1000),
      NewControlVendorCode NVARCHAR(1000),
      RevalMarketingAirlineCode NVARCHAR(1000),
      RevalClassofService NVARCHAR(1000),
      RevalMarketingFLightNbr NVARCHAR(1000),
      RevalServiceStartDate NVARCHAR(1000),
      RevalServiceStartCity NVARCHAR(1000),
      RevalServcieEndCity NVARCHAR(1000),
      RevalServiceStartTime NVARCHAR(1000),
      RevalServiceEndTime NVARCHAR(1000),
      RevalSegmentStatusCode NVARCHAR(1000),
      LastUpdate NVARCHAR(1000),
      LastUpdateSysTime NVARCHAR(1000),
      HistorySeqNbr NVARCHAR(1000)
		)
	  END

  PRINT 'Truncating temp_TktCouponHistory'
  TRUNCATE TABLE temp_TktCouponHistory

  set @bulk_insert_sql = 
    'BULK INSERT temp_TktCouponHistory FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''\n''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    SET @number_of_import_rows = (select count(*) from temp_TktCouponHistory)


    PRINT 'Ammending ' + cast(@number_of_import_rows as varchar) + ' rows to TktCouponHistory'

    update TktCouponHistory
    set RecordIndicator = tktch.RecordIndicator,
        PNRLocatorID = tktch.PNRLocatorID,
        PNRCreateDate = tktch.PNRCreateDate,
        TransactionDateTime = tktch.TransactionDateTime,
        CouponSeqNbr = tktch.CouponSeqNbr,
        FareBasisCode = tktch.FareBasisCode,
        CouponNbr = tktch.CouponNbr,
        PreviousCouponStatusCode = tktch.PreviousCouponStatusCode,
        NewCouponStatusCode = tktch.NewCouponStatusCode,
        CouponNbrChanged = tktch.CouponNbrChanged,
        PreviousControlVendorCode = tktch.PreviousControlVendorCode,
        NewControlVendorCode = tktch.NewControlVendorCode,
        RevalMarketingAirlineCode = tktch.RevalMarketingAirlineCode,
        RevalClassofService = tktch.RevalClassofService,
        RevalMarketingFLightNbr = tktch.RevalMarketingFLightNbr,
        RevalServiceStartDate = tktch.RevalServiceStartDate,
        RevalServiceStartCity = tktch.RevalServiceStartCity,
        RevalServcieEndCity = tktch.RevalServcieEndCity,
        RevalServiceStartTime = tktch.RevalServiceStartTime,
        RevalServiceEndTime = tktch.RevalServiceEndTime,
        RevalSegmentStatusCode = tktch.RevalSegmentStatusCode,
        LastUpdate = tktch.LastUpdate,
        LastUpdateSysTime = tktch.LastUpdateSysTime,
        HistorySeqNbr = tktch.HistorySeqNbr
          
  from	TktCouponHistory tch
        inner join temp_TktCouponHistory tktch on tktch.PrimaryDocNbr = tch.PrimaryDocNbr and tktch.VCRCreateDate = tch.VCRCreateDate
END;
GO