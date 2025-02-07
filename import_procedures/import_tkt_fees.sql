if OBJECT_ID('ImportTktFees', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportTktFees'
	drop procedure ImportTktFees
  END
GO

CREATE PROCEDURE dbo.ImportTktFees 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'TktFees' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_TktFees', 'U') is null
    BEGIN
	print 'Creating temp_TktFees'
		create table temp_TktFees(
      RecordIndicator	nchar(2),
      PrimaryDocNbr	char(17),
      VCRCreateDate	date,
      TransactionDateTime	time,
      SourceSystemId	char(2),
      FeeSequenceNbr	int,
      FeeTypeCd	char(10),
      FeeCatCd	char(3),
      FeeCurrCd	char(3),
      FeeAmt	decimal,
      FeeAmtUSD	decimal,
      ApplyCreditInd	char(1),
      FeeSubCategory	varchar(20),
      FeeWaivedInd	char(1),
      FeeDescription	varchar(21),
      FeePriceCd	char(1),
      FeeWaiverCd	char(3)
		)
	  END

  PRINT 'Truncating temp_TktFees'
  TRUNCATE TABLE temp_TktFees

  set @bulk_insert_sql = 
    'BULK INSERT temp_TktFees FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''0x0a''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    PRINT char(13) + char(13)
    PRINT 'Amending rows to TktFees' + char(13)

    update TktFees
    set RecordIndicator	= t2.RecordIndicator,
        TransactionDateTime	= t2.TransactionDateTime,
        SourceSystemId	= t2.SourceSystemId,
        FeeSequenceNbr	= t2.FeeSequenceNbr,
        FeeTypeCd	= t2.FeeTypeCd,
        FeeCatCd	= t2.FeeCatCd,
        FeeCurrCd	= t2.FeeCurrCd,
        FeeAmt	= t2.FeeAmt,
        FeeAmtUSD	= t2.FeeAmtUSD,
        ApplyCreditInd	= t2.ApplyCreditInd,
        FeeSubCategory	= t2.FeeSubCategory,
        FeeWaivedInd	= t2.FeeWaivedInd,
        FeeDescription	= t2.FeeDescription,
        FeePriceCd	= t2.FeePriceCd,
        FeeWaiverCd	= t2.FeeWaiverCd
          
  from	TktFees t1
        inner join temp_TktFees t2 on t1.PrimaryDocNbr = t2.PrimaryDocNbr
          and t1.VCRCreateDate = t2.VCRCreateDate
          and t1.SourceSystemId = t2.SourceSystemId
          and t1.FeeSequenceNbr = t2.FeeSequenceNbr
        
        
    PRINT char(13) + char(13)
    PRINT 'Appending rows to TktFees' + char(13)
    
    insert TktFees
    select *
    from   temp_TktFees t1
    where  not exists (
      select 1
      from   TktFees _t1
      where  _t1.PrimaryDocNbr = t1.PrimaryDocNbr
             and _t1.VCRCreateDate = t1.VCRCreateDate
             and _t1.SourceSystemId = t1.SourceSystemId
             and _t1.FeeSequenceNbr = t1.FeeSequenceNbr
    )
END;
GO
