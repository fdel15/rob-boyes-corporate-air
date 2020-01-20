if OBJECT_ID('ImportResRemark', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportResRemark'
	drop procedure ImportResRemark
  END
GO

CREATE PROCEDURE dbo.ImportResRemark 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'ResRemarks' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_ResRemark', 'U') is null
    BEGIN
	print 'Creating temp_ResRemark'
		create table temp_ResRemark(
      RecordIndicator	nchar(2),
      PNRLocatorID	char(6),
      PNRCreateDate	date,
      FromDateTime	time,
      ResRemarkSeqId	smallint,
      RemarkText	varchar(250),
      RemarkType	smallint,
      HistoryActionCodeId	char(4),
      RecordUpdateDate	date,
      RecordUpdateTime	time,
      IntraPNRSetNbr	smallint
		)
	  END

  PRINT 'Truncating temp_ResRemark'
  TRUNCATE TABLE temp_ResRemark

  set @bulk_insert_sql = 
    'BULK INSERT temp_ResRemark FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''\n''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    SET @number_of_import_rows = (select count(*) from temp_ResRemark)


    PRINT 'Ammending ' + cast(@number_of_import_rows as varchar) + ' rows to ResRemark'

    update ResRemark
    set RecordIndicator = t2.RecordIndicator,
        PNRLocatorID = t2.PNRLocatorID,
        PNRCreateDate = t2.PNRCreateDate,
        FromDateTime = t2.FromDateTime,
        ResRemarkSeqId = t2.ResRemarkSeqId,
        RemarkText = t2.RemarkText,
        RemarkType = t2.RemarkType,
        HistoryActionCodeId = t2.HistoryActionCodeId,
        RecordUpdateDate = t2.RecordUpdateDate,
        RecordUpdateTime = t2.RecordUpdateTime,
        IntraPNRSetNbr = t2.IntraPNRSetNbr

  from	ResRemark t1
        inner join temp_ResRemark t2 on t1.PNRLocatorID = t2.PNRLocatorID and t1.PNRCreateDate = t2.PNRCreateDate
END;
GO


-- EXEC ImportResRemark '20191224', 'E:\Sabre_FILES_tobedeleted\PROD\travelbatch\Extracted_DAT_Files'

-- select  column_name, column_name as equals from INFORMATION_SCHEMA.columns where table_name = 'ResRemark'
-- select column_name, data_type + isnull('(' + cast(character_maximum_length as varchar) + ')', '') from INFORMATION_SCHEMA.columns where table_name = 'ResRemark'

