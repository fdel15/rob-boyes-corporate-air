if OBJECT_ID('ImportResSSR', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportResSSR'
	drop procedure ImportResSSR
  END
GO

CREATE PROCEDURE dbo.ImportResSSR 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'ResSSR' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_ResSSR', 'U') is null
    BEGIN
	print 'Creating temp_ResSSR'
		create table temp_ResSSR(
      RecordIndicator NVARCHAR(1000),
      PNRLocatorID NVARCHAR(1000),
      PNRCreateDate NVARCHAR(1000),
      FromDateTime NVARCHAR(1000),
      ResSSRSeqId NVARCHAR(1000),
      PNRPassengerSeqId NVARCHAR(1000),
      SourceTypeCode NVARCHAR(1000),
      SSRIdTypeCode NVARCHAR(1000),
      SSRStatusCode NVARCHAR(1000),
      SSRFlightNumber NVARCHAR(1000),
      SSRNbrInParty NVARCHAR(1000),
      SSRStartDate NVARCHAR(1000),
      VendorCode NVARCHAR(1000),
      SSRCodes NVARCHAR(1000),
      SSRText NVARCHAR(1000),
      ClassOfService NVARCHAR(1000),
      ServiceStartCityCode NVARCHAR(1000),
      ServiceEndCityCode NVARCHAR(1000),
      HistoryActionCodeId NVARCHAR(1000),
      RecordUpdateDate NVARCHAR(1000),
      RecordUpdateTime NVARCHAR(1000),
      IntraPNRSetNbr NVARCHAR(1000)
		)
	  END

  PRINT 'Truncating temp_ResSSR'
  TRUNCATE TABLE temp_ResSSR

  set @bulk_insert_sql = 
    'BULK INSERT temp_ResSSR FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''\n''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    SET @number_of_import_rows = (select count(*) from temp_ResSSR)


    PRINT 'Ammending ' + cast(@number_of_import_rows as varchar) + ' rows to ResSSR'

    update ResSSR
    set RecordIndicator = tres.RecordIndicator,
        FromDateTime = tres.FromDateTime,
        ResSSRSeqId = tres.ResSSRSeqId,
        PNRPassengerSeqId = tres.PNRPassengerSeqId,
        SourceTypeCode = tres.SourceTypeCode,
        SSRIdTypeCode = tres.SSRIdTypeCode,
        SSRStatusCode = tres.SSRStatusCode,
        SSRFlightNumber = tres.SSRFlightNumber,
        SSRNbrInParty = tres.SSRNbrInParty,
        SSRStartDate = tres.SSRStartDate,
        VendorCode = tres.VendorCode,
        SSRCodes = tres.SSRCodes,
        SSRText = tres.SSRText,
        ClassOfService = tres.ClassOfService,
        ServiceStartCityCode = tres.ServiceStartCityCode,
        ServiceEndCityCode = tres.ServiceEndCityCode,
        HistoryActionCodeId = tres.HistoryActionCodeId,
        RecordUpdateDate = tres.RecordUpdateDate,
        RecordUpdateTime = tres.RecordUpdateTime,
        IntraPNRSetNbr = tres.IntraPNRSetNbr
          
  from	ResSSR r 
        inner join temp_ResSSR tres on r.PNRLocatorID = tres.PNRLocatorID and r.PNRCreateDate = tres.PNRCreateDate
END;
GO