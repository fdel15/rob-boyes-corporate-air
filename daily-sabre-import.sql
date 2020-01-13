CREATE PROCEDURE dbo.DailySabreImport @import_date = null

if( @import_date is null)
  set @import_date = cast(getdate() as date)


DECLARE @import_file_path NVARCHAR(512) = 'E:\Sabre_files\PROD\TDB Samplefiles.sabre\',
        @file_name NVARCHAR(512) = 'ACSFlight.xlsx',
		@full_file_name NVARCHAR(1024)

SET @full_file_name = @import_file_path + @file_name

 Append Data to tables

 ACSFlight

Declare @ACSFlight table(
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
  TotalPaxCoun NVARCHAR(1000)
)


BULK INSERT [@ACSFlight] FROM [@import_file_path + @file_name]
  WITH(
    DATAFILETYPE = 'char',
    FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
  );


select * from temp_ACSFlight

insert  dbo.ACSFlight(
        SourceSystemID,
        AirlineCode,
        FltNbr,
        ServiceStartDate,
        AirlineOrigAirport,
        AirlineDestAirport,
        SchdAirlineOrigAirport,
        SchdAirlineDestAirport,
        AirlineOrigGate,
        COGInd,
        FltOverFlyInd,
        FltFlagStopInd,
        FltStubInd,
        GateReaderLNIATA,
        EstServiceEndDate,
        EstServiceEndTime,
        EstServiceStartDate,
        EstServiceStartTime,
        SchdServiceStartDate,
        SchdServiceStartTime,
        SchdServiceEndDate,
        SchdServiceEndTime,
        FltCloseDate,
        FltCloseTime,
        PDCDate,
        PDCTime,
        FltLegDelayedInd,
        FltLegStatus,
        TailNbr,
        MsgCreateDateTime,
        EquipmentType,
        AircraftConfig,
        TotalPaxCount
)

select  * from @ACSFlight


-- Update Existing data in tables


