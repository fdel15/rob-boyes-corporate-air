if OBJECT_ID('ImportRes', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportRes'
	drop procedure ImportRes
  END
GO

CREATE PROCEDURE dbo.ImportRes 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'Res' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_Res', 'U') is null
    BEGIN
	print 'Creating temp_Res'
		create table temp_Res(
		  RecordIndicator NVARCHAR(1000),
		  PNRLocationId NVARCHAR(1000),
		  PNRCreateDate NVARCHAR(1000),
		  FromDateTime NVARCHAR(1000),
		  CreateAAACityCode NVARCHAR(1000),
		  CreationCountryCode NVARCHAR(1000),
		  GrpBookingInd NVARCHAR(1000),
		  CorporateInd NVARCHAR(1000),
		  NbrinParty NVARCHAR(1000),
		  TTYAirlineCode NVARCHAR(1000),
		  TTYRecordLocator NVARCHAR(1000),
		  TTYPosInformation NVARCHAR(1000),
		  SeatCount NVARCHAR(1000),
		  SourceSystemId NVARCHAR(1000),
		  PNRCreateTime NVARCHAR(1000),
		  CreateAgentSine NVARCHAR(1000),
		  NumberOfInfants NVARCHAR(1000),
		  ClaimIndicator NVARCHAR(1000),
		  CreateIATANr NVARCHAR(1000),
		  PurgeDate NVARCHAR(1000),
		  MaxIntraPNRSetNbr NVARCHAR(1000),
		  OrigPNRCreateDate NVARCHAR(1000),
		  OrigPNRCreateTime NVARCHAR(1000),
		  DivideImagePNRInd NVARCHAR(1000),
		  CreateAAAOACCityCode NVARCHAR(1000),
		  CreateAAAOACCAcctCode NVARCHAR(1000),
		  OACDefaultPartitionCode NVARCHAR(1000),
		  OACCityCode NVARCHAR(1000),
		  OACAcctCode NVARCHAR(1000),
		  OACStationNo NVARCHAR(1000),
		  CreateHomeCityCode NVARCHAR(1000),
		  CodeSharePNRInd NVARCHAR(1000),           
		  MCPCarrierInd NVARCHAR(1000)
		)
	  END

  PRINT 'Truncating temp_Res'
  TRUNCATE TABLE temp_Res

  set @bulk_insert_sql = 
    'BULK INSERT temp_Res FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''0x0a''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    SET @number_of_import_rows = (select count(*) from temp_Res)


    PRINT 'Ammending ' + cast(@number_of_import_rows as varchar) + ' rows to Res'

    update Res
    set FromDateTime = tr.FromDateTime,
        CreateAAACityCode = tr.CreateAAACityCode,
        CreationCountryCode = tr.CreationCountryCode,
        GrpBookingInd = tr.GrpBookingInd,
        CorporateInd = tr.CorporateInd,
        NbrinParty = tr.NbrinParty,
        TTYAirlineCode = tr.TTYAirlineCode,
        TTYRecordLocator = tr.TTYRecordLocator,
        TTYPosInformation = tr.TTYPosInformation,
        SeatCount = tr.SeatCount,
        SourceSystemId = tr.SourceSystemId,
        PNRCreateTime = tr.PNRCreateTime,
        CreateAgentSine = tr.CreateAgentSine,
        NumberOfInfants = tr.NumberOfInfants,
        ClaimIndicator = tr.ClaimIndicator,
        CreateIATANr = tr.CreateIATANr,
        PurgeDate = tr.PurgeDate,
        MaxIntraPNRSetNbr = tr.MaxIntraPNRSetNbr,
        OrigPNRCreateDate = tr.OrigPNRCreateDate,
        OrigPNRCreateTime = tr.OrigPNRCreateTime,
        DivideImagePNRInd = tr.DivideImagePNRInd,
        CreateAAAOACCityCode = tr.CreateAAAOACCityCode,
        CreateAAAOACCAcctCode = tr.CreateAAAOACCAcctCode,
        OACDefaultPartitionCode = tr.OACDefaultPartitionCode,
        OACCityCode = tr.OACCityCode,
        OACAcctCode = tr.OACAcctCode,
        OACStationNo = tr.OACStationNo,
        CreateHomeCityCode = tr.CreateHomeCityCode,
        MCPCarrierInd = tr.MCPCarrierInd
	
  from	Res r 
        inner join temp_Res tr on r.PNRLocationId = tr.PNRLocationId and r.PNRCreateDate = tr.PNRCreateDate
END;
GO

