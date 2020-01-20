if OBJECT_ID('ImportACSPaxFlight', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportACSPaxFlight'
	drop procedure ImportACSPaxFlight
  END
GO

CREATE PROCEDURE dbo.ImportACSPaxFlight 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'ACSPaxFlight' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_ACSPaxFlight', 'U') is null
    BEGIN
	print 'Creating temp_ACSPaxFlight'
		create table temp_ACSPaxFlight(
		  SourceSystemID NVARCHAR(1000),
		  PNRLocatorId NVARCHAR(1000),
		  MCPPNRLocatorId NVARCHAR(1000),
		  PNRCreateDate NVARCHAR(1000),
		  MCPPNRCreateDate NVARCHAR(1000),
		  ResPaxId NVARCHAR(1000),
		  AirlineCode NVARCHAR(1000),
		  FltNbr NVARCHAR(1000),
		  ServiceStartDate NVARCHAR(1000),
		  AirlineOrigAirport NVARCHAR(1000),
		  ResPaxNameID NVARCHAR(1000),
		  NameFirst NVARCHAR(1000),
		  NameLast NVARCHAR(1000),
		  PaxPNROrigin NVARCHAR(1000),
		  PaxPNRDest NVARCHAR(1000),
		  UPID NVARCHAR(1000),
		  PaxTypeCd NVARCHAR(1000),
		  RevenuePassengerInd NVARCHAR(1000),
		  NonRevenuePassengerind NVARCHAR(1000),
		  DeadheadInd NVARCHAR(1000),
		  SelecteeInd NVARCHAR(1000),
		  OnBrdInd NVARCHAR(1000),
		  BoardingPassInd NVARCHAR(1000),
		  PriorityListInd NVARCHAR(1000),
		  CheckInSeqNbr NVARCHAR(1000),
		  FlownClassofService NVARCHAR(1000),
		  ClassofService NVARCHAR(1000),
		  BookedInventory NVARCHAR(1000),
		  InventoryUpgradeInd NVARCHAR(1000),
		  MarketingAirlineCd NVARCHAR(1000),
		  MarketingFltNbr NVARCHAR(1000),
		  CodeShareAirlineCd NVARCHAR(1000),           
		  CodeShareAirlineFltNbr NVARCHAR(1000),
		  PaxThruInd NVARCHAR(1000),
		  PaxInboundConxInd NVARCHAR(1000),
		  PaxOutboundConxInd NVARCHAR(1000),
		  PaxCodeShareInd NVARCHAR(1000),
		  OneWorldConxInd NVARCHAR(1000),
		  OneWorldInConxInd NVARCHAR(1000),
		  OneWorldOutConxInd NVARCHAR(1000),
		  GenderInd NVARCHAR(1000),
		  CHGFLInd NVARCHAR(1000),
		  CHGSGInd NVARCHAR(1000),
		  GOSHOInd NVARCHAR(1000),
		  IDPADInd NVARCHAR(1000),
		  NORECInd NVARCHAR(1000),
		  NOSHOInd NVARCHAR(1000),
		  OFFLKInd NVARCHAR(1000),
		  OFFLNInd NVARCHAR(1000),
		  GOSHNInd NVARCHAR(1000),
		  CHGCLInd NVARCHAR(1000),
		  INVOLInd NVARCHAR(1000),     
		  APIPXInd NVARCHAR(1000),
		  CFMWLInd NVARCHAR(1000),
		  FQTVNInd NVARCHAR(1000),
		  CheckInGrpCode NVARCHAR(1000),
		  CheckinGrpCnt NVARCHAR(1000),
		  ResGrpCode NVARCHAR(1000),
		  ResGrpCnt NVARCHAR(1000),
		  PaxContactText NVARCHAR(1000),
		  ETCIInInd NVARCHAR(1000),
		  ETCIOutInd NVARCHAR(1000),
		  CheckInKioskInd NVARCHAR(1000),
		  RemoteCheckInInd NVARCHAR(1000),
		  CheckInMobileInd NVARCHAR(1000),
		  CheckInTime NVARCHAR(1000),
		  CheckInDate NVARCHAR(1000),
		  ChknRestrictedSOCInd NVARCHAR(1000),
		  VendorCode NVARCHAR(1000),
		  FrequentTravelerNbr NVARCHAR(1000),
		  FQTVTier NVARCHAR(1000),
		  PriorityListCd NVARCHAR(1000),
		  DeniedBoardType NVARCHAR(1000),
		  OverSaleLegID NVARCHAR(1000),
		  OverSaleReasonNbr NVARCHAR(1000),
		  OversaleCompensation NVARCHAR(1000),
		  CompTypeCd NVARCHAR(1000),
		  CompCurrCd NVARCHAR(1000),
		  OversaleReaccomInd NVARCHAR(1000),
		  UpgradeCd NVARCHAR(1000),
		  PaxCommentsText NVARCHAR(1000),
		  NbrOfBags NVARCHAR(1000),
		  TtlBagWeight NVARCHAR(1000),
		  ExcessBagInd NVARCHAR(1000),
		  NSTInd NVARCHAR(1000),
		  OFLInd NVARCHAR(1000),
		  STCHInd NVARCHAR(1000),
		  BCSInd NVARCHAR(1000),
		  SSUPInd NVARCHAR(1000),
		  SSPRInd NVARCHAR(1000),
		  WVERInd NVARCHAR(1000),
		  INCUInd NVARCHAR(1000),
		  OXYGInd NVARCHAR(1000),
		  NMELInd NVARCHAR(1000),
		  GCIPInd NVARCHAR(1000),
		  GVIPInd NVARCHAR(1000),
		  MsgCreateDateTime NVARCHAR(1000),
		  APPInfantInd NVARCHAR(1000),
		  APPAuthCountry NVARCHAR(1000),
		  APPStatus NVARCHAR(1000),
		  SSRCode NVARCHAR(1000),      
		  SSRText NVARCHAR(1000),
		  PaxInboundCarrier NVARCHAR(1000),
		  PaxInboundFlightNbr NVARCHAR(1000),
		  PaxInbSvcStDt NVARCHAR(1000),
		  PaxInbSvcStTm NVARCHAR(1000),
		  PaxInbOrigin NVARCHAR(1000),
		  PaxInbDest NVARCHAR(1000),
		  PaxInbBookedClass NVARCHAR(1000),
		  PaxOutboundCarrier NVARCHAR(1000),
      PaxOutboundFlightNbr NVARCHAR(1000),
		  PaxOutbSvcStDt NVARCHAR(1000),
		  PaxOutbSvcStTm NVARCHAR(1000),
		  PaxOutbOrigin NVARCHAR(1000),
		  PaxOutbDest NVARCHAR(1000),
      PaxOutbBookedClass NVARCHAR(1000)
		)
	  END

  PRINT 'Truncating temp_ACSPaxFlight'
  TRUNCATE TABLE temp_ACSPaxFlight

  set @bulk_insert_sql = 
    'BULK INSERT temp_ACSPaxFlight FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''\n''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    SET @number_of_import_rows = (select count(*) from temp_ACSPaxFlight)


    PRINT 'APPENDING ' + cast(@number_of_import_rows as varchar) + ' rows to ACSPaxFlight'

    insert ACSPaxFlight
    select	* 
	from	temp_ACSPaxFlight tacspf
	where	not exists (
		select	1
		from	ACSPaxFlight _acspf
		where	tacspf.SourceSystemID = _acspf.SourceSystemID
				and tacspf.PNRLocatorId = _acspf.PNRLocatorId
				and	tacspf.PNRCreateDate = _acspf.PNRCreateDate
        and	tacspf.ResPaxId = _acspf.ResPaxId
        and	tacspf.AirlineCode = _acspf.AirlineCode
        and	tacspf.FltNbr = _acspf.FltNbr
        and	tacspf.ServiceStartDate = _acspf.ServiceStartDate
        and	tacspf.AirlineOrigAirport = _acspf.AirlineOrigAirport
				and	tacspf.MCPPNRLocatorId = _acspf.MCPPNRLocatorId
				and	tacspf.MCPPNRCreateDate = _acspf.MCPPNRCreateDate
				and	tacspf.ResPaxNameID = _acspf.ResPaxNameID            
    )
END;
GO
