if OBJECT_ID('ImportTktTax', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportTktTax'
	drop procedure ImportTktTax
  END
GO

CREATE PROCEDURE dbo.ImportTktTax 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'TktTax' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_TktTax', 'U') is null
    BEGIN
	print 'Creating temp_TktTax'
		create table temp_TktTax(
      RecordIndicator	nchar(2),
      PNRLocatorID	char(6),
      PNRCreateDate	date,
      PrimaryDocNbr	char(13),
      VCRCreateDate	date,
      TransactionDateTime	time,
      TaxSeqNbr	tinyint,
      TaxAmt	decimal,
      TaxCode	char(3),
      TaxTypeCode	char(1),
      TaxCategoryCode	char(3),
      TaxCurrCode	char(3)
		)
	  END

  PRINT 'Truncating temp_TktTax'
  TRUNCATE TABLE temp_TktTax

  set @bulk_insert_sql = 
    'BULK INSERT temp_TktTax FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''0x0a''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    PRINT char(13) + char(13)
    PRINT 'Amending rows to TktTax' + char(13)

    update TktTax
    set RecordIndicator	= t2.RecordIndicator,
        PNRLocatorID	= t2.PNRLocatorID,
        PNRCreateDate	= t2.PNRCreateDate,
        TransactionDateTime	= t2.TransactionDateTime,
        TaxSeqNbr	= t2.TaxSeqNbr,
        TaxAmt	= t2.TaxAmt,
        TaxCode	= t2.TaxCode,
        TaxTypeCode	= t2.TaxTypeCode,
        TaxCategoryCode	= t2.TaxCategoryCode,
        TaxCurrCode	= t2.TaxCurrCode

  from	TktTax t1
        inner join temp_TktTax t2 on t1.PrimaryDocNbr = t2.PrimaryDocNbr
          and t1.VCRCreateDate = t2.VCRCreateDate
          and t1.TaxSeqNbr = t2.TaxSeqNbr
          and t1.TaxCode = t2.TaxCode
          and t1.TaxCategoryCode = t2.TaxCategoryCode
          
        
        
    PRINT char(13) + char(13)
    PRINT 'Appending rows to TktTax' + char(13)
    
    insert TktTax
    select *
    from   temp_TktTax t1
    where  not exists (
      select 1
      from   TktTax _t1
      where _t1.PrimaryDocNbr = t1.PrimaryDocNbr
        and _t1.VCRCreateDate = t1.VCRCreateDate
        and _t1.TaxSeqNbr = t1.TaxSeqNbr
        and _t1.TaxCode = t1.TaxCode
        and _t1.TaxCategoryCode = t1.TaxCategoryCode
    )
END;
GO
