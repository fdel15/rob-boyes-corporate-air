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
      RecordIndicator nchar(2),
      PNRLocationID char(6),
      PNRCreateDate date,
      FromDateTime datetime2,
      CreateAAACityCode char(5),
      CreationCountryCode char(3),
      GrpBookingInd char(1),
      CorporateInd char(1),
      NbrinParty smallint,
      TTYAirlineCode char(3),
      TTYRecordLocator varchar(8),
      TTYPosInformation varchar(250),
      SeatCount smallint,
      SourceSystemId char(2),
      PNRCreateTime time,
      CreateAgentSine char(3),
      NumberOfInfants smallint,
      ClaimIndicator char(1),
      CreateIATANr char(11),
      PurgeDate date,
      MaxIntraPNRSetNbr smallint,
      DivideOrigPNRLocatorID char(6),
      OrigPNRCreateDate date,
      OrigPNRCreateTime time,
      DivideImagePNRInd char(1),
      CreateAAAOACCityCode char(5),
      CreateAAAOACCAcctCode char(3),
      OACDefaultPartitionCode char(3),
      OACCityCode char(5),
      OACAcctCode char(3),
      OACStationNo char(14),
      CreateHomeCityCode char(5),
      CodeSharePNRInd char(1),
      MCPCarrierInd char(1)
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

