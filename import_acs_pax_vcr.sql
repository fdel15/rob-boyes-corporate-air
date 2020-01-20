if OBJECT_ID('ImportACSPaxVCR', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportACSPaxVCR'
	drop procedure ImportACSPaxVCR
  END
GO

CREATE PROCEDURE dbo.ImportACSPaxVCR 
    @date_string varchar(8), -- yyyymmdd
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'ACSPaxVCR' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_ACSPaxVCR', 'U') is null
    BEGIN
	print 'Creating temp_ACSPaxVCR'
		create table temp_ACSPaxVCR(
		  SourceSystemID NVARCHAR(1000),
		  PNRLocatorId NVARCHAR(1000),
		  PNRCreateDate NVARCHAR(1000),
		  ResPaxId NVARCHAR(1000),
		  AirlineCode NVARCHAR(1000),
		  FltNbr NVARCHAR(1000),
		  ServiceStartDate NVARCHAR(1000),
		  AirlineOrigAirport NVARCHAR(1000),
		  VCRCreateDate NVARCHAR(1000),
		  AirlineAccountingCode NVARCHAR(1000),
		  VCRSerialNbr NVARCHAR(1000),
		  VCRCouponSeqNbr NVARCHAR(1000),
		  ClassofService NVARCHAR(1000),
		  FareBasisCode NVARCHAR(1000),
		  VCRInUseInd NVARCHAR(1000),
		  VCRSelectDisAssocInd NVARCHAR(1000),
		  VCRDisAssocInd NVARCHAR(1000),
		  VCRDisAssocRsn NVARCHAR(1000),
		  VCRGrabNGoInd NVARCHAR(1000),
		  CommonElecTktInd NVARCHAR(1000),
		  VCRExistInd NVARCHAR(1000),
		  MultiVCRInd NVARCHAR(1000),
		  PrevCpnStatsErrInd NVARCHAR(1000),
		  PrevCpnStatsErrOverrideInd NVARCHAR(1000),
		  InfVCRInd NVARCHAR(1000),
		  InfVCRIssueDate NVARCHAR(1000),
		  InfVCRCreateDate NVARCHAR(1000),
		  InfVCRCreateTime NVARCHAR(1000),
		  InfVCRAirlineAccountingCode NVARCHAR(1000),
		  InfVCRSerialNbr NVARCHAR(1000),
		  InfVCRCouponSeqNbr NVARCHAR(1000),
		  InfVCRFareBasisCode NVARCHAR(1000),
		  InfVCRClassofService NVARCHAR(1000),
		  InfVCRInUseInd NVARCHAR(100),
		  InfCheckInComplete NVARCHAR(100),
		  MsgCreateDateTime NVARCHAR(100),
		)
	  END

  PRINT 'Truncating temp_ACSPaxVCR'
  TRUNCATE TABLE temp_ACSPaxVCR

  set @bulk_insert_sql = 
    'BULK INSERT temp_ACSPaxVCR FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''\n''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    SET @number_of_import_rows = (select count(*) from temp_ACSPaxVCR)


    PRINT 'APPENDING ' + cast(@number_of_import_rows as varchar) + ' rows to ACSPaxVCR'

    insert ACSPaxVCR
    select	* 
	from	temp_ACSPaxVCR tacsp
	where	not exists (
		select	1
		from	ACSPaxVCR _acsp
		where	tacsp.SourceSystemID = _acsp.SourceSystemID
				and tacsp.PNRLocatorId = _acsp.PNRLocatorId
				and	tacsp.PNRCreateDate = _acsp.PNRCreateDate
        and	tacsp.ResPaxId = _acsp.ResPaxId
        and	tacsp.AirlineCode = _acsp.AirlineCode
        and	tacsp.FltNbr = _acsp.FltNbr
        and	tacsp.ServiceStartDate = _acsp.ServiceStartDate
        and	tacsp.AirlineOrigAirport = _acsp.AirlineOrigAirport        
    )

END;
GO

