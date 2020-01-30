if OBJECT_ID('ImportTktProration', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportTktProration'
	drop procedure ImportTktProration
  END
GO

CREATE PROCEDURE dbo.ImportTktProration 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'TktProration' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_TktProration', 'U') is null
    BEGIN
	print 'Creating temp_TktProration'
		create table temp_TktProration(
      RecordIndicator nchar(2),
      PNRLocatorID char(6),
      PNRCreateDate date,
      PrimaryDocNbr char(13),
      VCRCreateDate date,
      TransactionDateTime time,
      CouponSeqNbr smallint,
      CouponDistanceKm decimal,
      CouponDistanceMi decimal,
      ProrationFactor decimal,
      ProrateBaseFareUSD decimal,
      ProrateTotalDocAmtUSD decimal,
      EquivBaseFareCurrCode char(3),
      EquivUSDExchgRate decimal,
      ProrateEquivBaseFareAmt decimal,
      ProrateEquivTotalDocAmt decimal,
      OwnerCurrencyCode char(3),
      ProrateBaseFareOwnerAmt decimal,
      ProrateTotalDocOwnerAmt decimal
		)
	  END

  PRINT 'Truncating temp_TktProration'
  TRUNCATE TABLE temp_TktProration

  set @bulk_insert_sql = 
    'BULK INSERT temp_TktProration FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''0x0a''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    PRINT char(13) + char(13)
    PRINT 'Ammending rows to TktProration' + char(13)

    update TktProration
    set RecordIndicator = t2.RecordIndicator,
        PNRLocatorID = t2.PNRLocatorID,
        PNRCreateDate = t2.PNRCreateDate,
        PrimaryDocNbr = t2.PrimaryDocNbr,
        VCRCreateDate = t2.VCRCreateDate,
        TransactionDateTime = t2.TransactionDateTime,
        CouponSeqNbr = t2.CouponSeqNbr,
        CouponDistanceKm = t2.CouponDistanceKm,
        CouponDistanceMi = t2.CouponDistanceMi,
        ProrationFactor = t2.ProrationFactor,
        ProrateBaseFareUSD = t2.ProrateBaseFareUSD,
        ProrateTotalDocAmtUSD = t2.ProrateTotalDocAmtUSD,
        EquivBaseFareCurrCode = t2.EquivBaseFareCurrCode,
        EquivUSDExchgRate = t2.EquivUSDExchgRate,
        ProrateEquivBaseFareAmt = t2.ProrateEquivBaseFareAmt,
        ProrateEquivTotalDocAmt = t2.ProrateEquivTotalDocAmt,
        OwnerCurrencyCode = t2.OwnerCurrencyCode,
        ProrateBaseFareOwnerAmt = t2.ProrateBaseFareOwnerAmt,
        ProrateTotalDocOwnerAmt = t2.ProrateTotalDocOwnerAmt
          
  from	TktProration t1
        inner join temp_TktProration t2 on t2.PrimaryDocNbr = t1.PrimaryDocNbr and t2.VCRCreateDate = t1.VCRCreateDate
        
    PRINT char(13) + char(13)
    PRINT 'Appending rows to TktProration' + char(13)
    
    insert TktProration
    select *
    from   temp_TktProration t1
    where  not exists (
      select 1
      from   TktProration _t1
      where _t1.PrimaryDocNbr = t1.PrimaryDocNbr and _t1.VCRCreateDate = t1.VCRCreateDate
    )
END;
GO
