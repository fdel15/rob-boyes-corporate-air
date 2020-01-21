if OBJECT_ID('ImportACSFlight', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportACSFlight'
	drop procedure ImportACSFlight
  END
GO

CREATE PROCEDURE dbo.ImportACSFlight 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'ACSFlight' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_ACSFlight', 'U') is null
    BEGIN
	print 'Creating temp_ACSFlight'
		create table temp_ACSFlight(
		  SourceSystemID NVARCHAR(1000),
		  AirlineCode NVARCHAR(1000),
		  FltNbr NVARCHAR(1000),
		  ServiceStartDate NVARCHAR(1000),
		  AirlineOrigAirport NVARCHAR(1000),
		  AirlineDestAirport NVARCHAR(1000),
		  SchdAirlineOrigAirport NVARCHAR(1000),
		  SchdAirlineDestAirport NVARCHAR(1000),
		  AirlineOrigGate NVARCHAR(1000),
		  COGInd NVARCHAR(1000),
		  FltOverFlyInd NVARCHAR(1000),
		  FltFlagStopInd NVARCHAR(1000),
		  FltStubInd NVARCHAR(1000),
		  GateReaderLNIATA NVARCHAR(1000),
		  EstServiceEndDate NVARCHAR(1000),
		  EstServiceEndTime NVARCHAR(1000),
		  EstServiceStartDate NVARCHAR(1000),
		  EstServiceStartTime NVARCHAR(1000),
		  SchdServiceStartDate NVARCHAR(1000),
		  SchdServiceStartTime NVARCHAR(1000),
		  SchdServiceEndDate NVARCHAR(1000),
		  SchdServiceEndTime NVARCHAR(1000),
		  FltCloseDate NVARCHAR(1000),
		  FltCloseTime NVARCHAR(1000),
		  PDCDate NVARCHAR(1000),
		  PDCTime NVARCHAR(1000),
		  FltLegDelayedInd NVARCHAR(1000),
		  FltLegStatus NVARCHAR(1000),
		  TailNbr NVARCHAR(1000),
		  MsgCreateDateTime NVARCHAR(1000),
		  EquipmentType NVARCHAR(1000),
		  AircraftConfig NVARCHAR(1000),
		  TotalPaxCount NVARCHAR(1000),
		  ReservedFutureUse1 NVARCHAR(100),
		  ReservedFutureUse2 NVARCHAR(100),
		  ReservedFutureUse3 NVARCHAR(100),
		  ReservedFutureUse4 NVARCHAR(100),
		  ReservedFutureUse5 NVARCHAR(100),
		  ReservedFutureUse6 NVARCHAR(100),
		  ReservedFutureUse7 NVARCHAR(100),
		  ReservedFutureUse8 NVARCHAR(100),
		  ReservedFutureUse9 NVARCHAR(100)
		)
	  END

  PRINT 'Truncating temp_ACSFlight'
  TRUNCATE TABLE temp_ACSFLIGHT

  set @bulk_insert_sql = 
    'BULK INSERT temp_ACSFlight FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''\n''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    SET @number_of_import_rows = (select count(*) from temp_ACSFlight)


    PRINT 'APPENDING ' + cast(@number_of_import_rows as varchar) + ' rows to ACSFlilght'

    insert ACSFlight
    select	* 
	from	temp_ACSFlight tacsf
	where	not exists (
		select	1
		from	ACSFlight _acsf
		where	tacsf.SourceSystemID = _acsf.SourceSystemID
				and tacsf.AirlineCode = _acsf.AirlineCode
				and	tacsf.FltNbr = _acsf.FltNbr
				and tacsf.ServiceStartDate = _acsf.ServiceStartDate
				and tacsf.SchdServiceStartTime = _acsf.SchdServiceStartTime
				and tacsf.SchdServiceEndTime = _acsf.SchdServiceEndTime
	)

END;
GO

