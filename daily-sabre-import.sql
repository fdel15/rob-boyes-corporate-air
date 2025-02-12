if OBJECT_ID('DailySabreImport', 'P') is not null
  BEGIN
    print 'Dropping procedure DailySabreImport'
	  drop procedure DailySabreImport
  END
GO

CREATE PROCEDURE dbo.DailySabreImport
  @import_date varchar(25) = null,
  @import_file_path nvarchar(512) = null

AS
BEGIN

  if (@import_date is null)
    set @import_date = convert(varchar, getdate() - 1, 112)
  else
    set @import_date = (select replace(@import_date, '-', ''))


-- Tries to ensure that the import date will match a file name if the script is
-- manually ran
IF( 1 <> (SELECT ISNUMERIC(@import_date)) OR 8 <> (SELECT LEN(@import_date)))
  BEGIN
    RAISERROR('Invalid date format. Import date must be specified as yyyy-mm-dd', 16, 1)
    return
  END
  
  if @import_file_path is null
    set @import_file_path = '\\10.10.10.8\Sabre\Files\travelbatch\Extracted_DAT_Files'

  -- APPENDS DATA To existing table

  EXEC ImportACSFlight @import_date, @import_file_path
  EXEC ImportACSPaxVCR @import_date, @import_file_path
  EXEC ImportACSPaxFlight @import_date, @import_file_path

  -- AMMENDS Existing data in table AND APPENDS new data
  EXEC ImportRes @import_date, @import_file_path
  EXEC ImportResPassenger @import_date, @import_file_path
  EXEC ImportResRemark @import_date, @import_file_path
  EXEC ImportResSSR @import_date, @import_file_path

  EXEC ImportTktCoupon @import_date, @import_file_path
  EXEC ImportTktCouponHistory @import_date, @import_file_path
  EXEC ImportTktDocument @import_date, @import_file_path
  EXEC ImportTktFees @import_date, @import_file_path
  EXEC ImportTktTax @import_date, @import_file_path
  EXEC ImportTktProration @import_date, @import_file_path



END;
GO

-- EXEC DailySabreImport '2020-12-06', 'E:\Sabre_FILES_tobedeleted\PROD\travelbatch\Extracted_DAT_Files'

