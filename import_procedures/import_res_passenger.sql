if OBJECT_ID('ImportResPassenger', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportResPassenger'
	drop procedure ImportResPassenger
  END
GO

CREATE PROCEDURE dbo.ImportResPassenger 
    @date_string varchar(10),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'ResPassenger' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000)

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_ResPassenger', 'U') is null
    BEGIN
	print 'Creating temp_ResPassenger'
		create table temp_ResPassenger(
	    RecordIndicator NVARCHAR(1000),
      PNRLocatorID NVARCHAR(1000),
      PNRCreateDate NVARCHAR(1000),
      FromDateTime NVARCHAR(1000),
      PNRPassengerSeqId NVARCHAR(1000),
      NameFirst NVARCHAR(1000),
      NameLast NVARCHAR(1000),
      NameComment NVARCHAR(1000),
      RelativePassengerNbr NVARCHAR(1000),
      HistoryActionCodeId NVARCHAR(1000),
      RecordUpdateDate NVARCHAR(1000),
      RecordUpdateTime NVARCHAR(1000),
      IntraPNRSetNbr VARCHAR(1000)
	)
	  END

  PRINT 'Truncating temp_ResPassenger'
  TRUNCATE TABLE temp_ResPassenger

  set @bulk_insert_sql = 
    'BULK INSERT temp_ResPassenger FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''0x0a''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)
    
    PRINT char(13) + char(13)

    PRINT 'Ammending rows to ResPassenger' + char(13)

    update ResPassenger
    set RecordIndicator = trp.RecordIndicator,
        FromDateTime = trp.FromDateTime,
        PNRPassengerSeqId = trp.PNRPassengerSeqId,
        NameFirst = trp.NameFirst,
        NameLast = trp.NameLast,
        NameComment = trp.NameComment,
        RelativePassengerNbr = trp.RelativePassengerNbr,
        HistoryActionCodeId = trp.HistoryActionCodeId,
        RecordUpdateDate = trp.RecordUpdateDate,
        RecordUpdateTime = trp.RecordUpdateTime,
        IntraPNRSetNbr = trp.IntraPNRSetNbr
          
  from	ResPassenger r 
        inner join temp_ResPassenger trp on r.PNRLocatorID = trp.PNRLocatorID
          and r.PNRCreateDate = trp.PNRCreateDate
          and r.PNRPassengerSeqId = trp.PNRPassengerSeqId
          and r.RelativePassengerNbr = trp.RelativePassengerNbr
          and r.NameFirst = trp.NameFirst
          and r.NameComment = trp.NameComment
          and r.HistoryActionCodeId = trp.HistoryActionCodeId
          and r.IntraPNRSetNbr = trp.IntraPNRSetNbr
        
  
   PRINT char(13) + char(13)
   PRINT 'Appending rows to ResPassenger' + char(13)
        
   insert ResPassenger
   select *
   
   from   temp_ResPassenger tr
   
   where  not exists (
     select 1
     
     from   ResPassenger _rp
     
     where _rp.PNRLocatorID = tr.PNRLocatorID 
          and _rp.PNRCreateDate = tr.PNRCreateDate
          and _rp.PNRPassengerSeqId = tr.PNRPassengerSeqId
          and _rp.RelativePassengerNbr = tr.RelativePassengerNbr
          and _rp.NameFirst = tr.NameFirst
          and _rp.NameComment = tr.NameComment
          and _rp.HistoryActionCodeId = tr.HistoryActionCodeId
          and _rp.IntraPNRSetNbr = tr.IntraPNRSetNbr
   )
END;
GO

