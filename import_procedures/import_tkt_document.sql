if OBJECT_ID('ImportTktDocument', 'P') is not null
  BEGIN
    print 'Dropping procedure ImportTktDocument'
	drop procedure ImportTktDocument
  END
GO

CREATE PROCEDURE dbo.ImportTktDocument 
    @date_string varchar(8),
    @file_path varchar(512)
AS
BEGIN
  
  DECLARE @file_name varchar(512) = 'TktDocument' + '_' + @date_string +'.dat',
          @full_file_name varchar(1500),
          @bulk_insert_sql varchar(4000),
          @number_of_import_rows int

  SET @full_file_name = @file_path + '\' + @file_name

  if OBJECT_ID('temp_TktDocument', 'U') is null
    BEGIN
	print 'Creating temp_TktDocument'
		create table temp_TktDocument(
      RecordIndicator NVARCHAR(1000),
      PNRLocatorID NVARCHAR(1000),
      PNRCreateDate NVARCHAR(1000),
      PrimaryDocNbr NVARCHAR(1000),
      VCRCreateDate NVARCHAR(1000),
      TransactionDateTime NVARCHAR(1000),
      AirlineAccountingCode NVARCHAR(1000),
      EndDocNbr NVARCHAR(1000),
      VendorName NVARCHAR(1000),
      PointOfTheTktIssueance NVARCHAR(1000),
      ValidatingVendorCode NVARCHAR(1000),
      ValidatingVendorNbr NVARCHAR(1000),
      PNRPurgeDate NVARCHAR(1000),
      CRSPNRLocator NVARCHAR(1000),
      DocIssueDate NVARCHAR(1000),
      CustomerFullName NVARCHAR(1000),
      AgentCountryCode NVARCHAR(1000),
      IntlDocSaleCode NVARCHAR(1000),
      TourCode NVARCHAR(1000),
      AgentSine NVARCHAR(1000),
      OwningCityCode NVARCHAR(1000),
      AAACityCode NVARCHAR(1000),
      DocIssueAAAIATANbr NVARCHAR(1000),
      HomeCityCode NVARCHAR(1000),
      Restrictions NVARCHAR(1000),
      CurrConverRate NVARCHAR(1000),
      BankSellRate NVARCHAR(1000),
      BankBuyRate NVARCHAR(1000),
      IntlClearHouseRate NVARCHAR(1000),
      ExchgTktAmt NVARCHAR(1000),
      SettlementAuthCode NVARCHAR(1000),
      BaseFareCurrCode NVARCHAR(1000),
      BaseFareAmt NVARCHAR(1000),
      TotalFareCurrCode NVARCHAR(1000),
      TotalDocAmt NVARCHAR(1000),
      EquivBaseFareCurrCode NVARCHAR(1000),
      EquivBaseFareAmt NVARCHAR(1000),
      DataInd NVARCHAR(1000),
      FareCalc NVARCHAR(1000),
      FareCalcType NVARCHAR(1000),
      OriginalIssueDate NVARCHAR(1000),
      OrigianlIssueCity NVARCHAR(1000),
      OrigianlIATANbr NVARCHAR(1000),
      OriginalFOP NVARCHAR(1000),
      OriginalTktNbr NVARCHAR(1000),
      ExchgFOP NVARCHAR(1000),
      Add1ExchgTktData NVARCHAR(1000),
      ExchgCoupon NVARCHAR(1000),
      AutoPriceCode NVARCHAR(1000),
      DocTypeCode NVARCHAR(1000),
      DocStatusCode NVARCHAR(1000),
      PassengerType NVARCHAR(1000),
      SourceSystemId NVARCHAR(1000),
      OACStationNbr NVARCHAR(1000),
      RefundableInd NVARCHAR(1000),
      CommissionableInd NVARCHAR(1000),
      InterlineInd NVARCHAR(1000),
      EMDRFICode NVARCHAR(1000),
      EMDType NVARCHAR(1000),
      TaxExInd NVARCHAR(1000),
      ConsumedAtIssueInd NVARCHAR(1000),
      ElectronicDocumentInd NVARCHAR(1000),
      ManualDocumentInd NVARCHAR(1000),
      VoucherRefundInd NVARCHAR(1000),
      RFICode NVARCHAR(1000),
      RFITxt NVARCHAR(1000),
      PTASvcChargeCurrCode NVARCHAR(1000),
      PTASvcChargeAmt NVARCHAR(1000),
      PTAAddFundsDesc NVARCHAR(1000),
      PTAAddFundsCurrCode NVARCHAR(1000),
      PTAAddFundsAmt NVARCHAR(1000),
      ExchgChangeFeeCurrCode NVARCHAR(1000),
      ExchgChangeFeeAmt NVARCHAR(1000),
      OtherFeeCurrCode NVARCHAR(1000),
      OtherFeeAmt NVARCHAR(1000),
      AddCollectCurrCode NVARCHAR(1000),
      AddCollectAmt NVARCHAR(1000),
      OACDefaultPartitionCode NVARCHAR(1000),
      OACCityCode NVARCHAR(1000),
      OACAcctCode NVARCHAR(1000),
      NonRefFeeCurrCode NVARCHAR(1000),
      NonRefFeeAmt NVARCHAR(1000),
      OBFeeDescText NVARCHAR(1000),
      OBFeePricingCode NVARCHAR(1000),
      OBFeeWaiverCode NVARCHAR(1000),
      OBFeeTotalCurrCode NVARCHAR(1000),
      OBFeeTotal NVARCHAR(1000),
      OBFeeTotalUSD NVARCHAR(1000),
      PricedPassengerType NVARCHAR(1000)
		)
	  END

  PRINT 'Truncating temp_TktDocument'
  TRUNCATE TABLE temp_TktDocument

  set @bulk_insert_sql = 
    'BULK INSERT temp_TktDocument FROM ''' + @full_file_name + ''' ' +
    'WITH(
      DATAFILETYPE = ''char'',
      FIELDTERMINATOR = ''|'',
      ROWTERMINATOR = ''0x0a''
    )'

    PRINT 'Bulk inserting data from ' + @full_file_name + ' into temp table'

    EXEC(@bulk_insert_sql)

    PRINT char(13) + char(13)
    PRINT 'Amending rows to TktDocument' + char(13)

    update TktDocument
    set RecordIndicator	= t2.RecordIndicator,
        PNRLocatorID	= t2.PNRLocatorID,
        VCRCreateDate	= t2.VCRCreateDate,
        TransactionDateTime	= t2.TransactionDateTime,
        AirlineAccountingCode	= t2.AirlineAccountingCode,
        EndDocNbr	= t2.EndDocNbr,
        VendorName	= t2.VendorName,
        PointOfTheTktIssueance	= t2.PointOfTheTktIssueance,
        ValidatingVendorCode	= t2.ValidatingVendorCode,
        ValidatingVendorNbr	= t2.ValidatingVendorNbr,
        PNRPurgeDate	= t2.PNRPurgeDate,
        CRSPNRLocator	= t2.CRSPNRLocator,
        DocIssueDate	= t2.DocIssueDate,
        CustomerFullName	= t2.CustomerFullName,
        AgentCountryCode	= t2.AgentCountryCode,
        IntlDocSaleCode	= t2.IntlDocSaleCode,
        TourCode	= t2.TourCode,
        AgentSine	= t2.AgentSine,
        OwningCityCode	= t2.OwningCityCode,
        AAACityCode	= t2.AAACityCode,
        DocIssueAAAIATANbr	= t2.DocIssueAAAIATANbr,
        HomeCityCode	= t2.HomeCityCode,
        Restrictions	= t2.Restrictions,
        CurrConverRate	= t2.CurrConverRate,
        BankSellRate	= t2.BankSellRate,
        BankBuyRate	= t2.BankBuyRate,
        IntlClearHouseRate	= t2.IntlClearHouseRate,
        ExchgTktAmt	= t2.ExchgTktAmt,
        SettlementAuthCode	= t2.SettlementAuthCode,
        BaseFareCurrCode	= t2.BaseFareCurrCode,
        BaseFareAmt	= t2.BaseFareAmt,
        TotalFareCurrCode	= t2.TotalFareCurrCode,
        TotalDocAmt	= t2.TotalDocAmt,
        EquivBaseFareCurrCode	= t2.EquivBaseFareCurrCode,
        EquivBaseFareAmt	= t2.EquivBaseFareAmt,
        DataInd	= t2.DataInd,
        FareCalc	= t2.FareCalc,
        FareCalcType	= t2.FareCalcType,
        OriginalIssueDate	= t2.OriginalIssueDate,
        OrigianlIssueCity	= t2.OrigianlIssueCity,
        OrigianlIATANbr	= t2.OrigianlIATANbr,
        OriginalFOP	= t2.OriginalFOP,
        OriginalTktNbr	= t2.OriginalTktNbr,
        ExchgFOP	= t2.ExchgFOP,
        Add1ExchgTktData	= t2.Add1ExchgTktData,
        ExchgCoupon	= t2.ExchgCoupon,
        AutoPriceCode	= t2.AutoPriceCode,
        DocTypeCode	= t2.DocTypeCode,
        DocStatusCode	= t2.DocStatusCode,
        PassengerType	= t2.PassengerType,
        SourceSystemId	= t2.SourceSystemId,
        OACStationNbr	= t2.OACStationNbr,
        RefundableInd	= t2.RefundableInd,
        CommissionableInd	= t2.CommissionableInd,
        InterlineInd	= t2.InterlineInd,
        EMDRFICode	= t2.EMDRFICode,
        EMDType	= t2.EMDType,
        TaxExInd	= t2.TaxExInd,
        ConsumedAtIssueInd	= t2.ConsumedAtIssueInd,
        ElectronicDocumentInd	= t2.ElectronicDocumentInd,
        ManualDocumentInd	= t2.ManualDocumentInd,
        VoucherRefundInd	= t2.VoucherRefundInd,
        RFICode	= t2.RFICode,
        RFITxt	= t2.RFITxt,
        PTASvcChargeCurrCode	= t2.PTASvcChargeCurrCode,
        PTASvcChargeAmt	= t2.PTASvcChargeAmt,
        PTAAddFundsDesc	= t2.PTAAddFundsDesc,
        PTAAddFundsCurrCode	= t2.PTAAddFundsCurrCode,
        PTAAddFundsAmt	= t2.PTAAddFundsAmt,
        ExchgChangeFeeCurrCode	= t2.ExchgChangeFeeCurrCode,
        ExchgChangeFeeAmt	= t2.ExchgChangeFeeAmt,
        OtherFeeCurrCode	= t2.OtherFeeCurrCode,
        OtherFeeAmt	= t2.OtherFeeAmt,
        AddCollectCurrCode	= t2.AddCollectCurrCode,
        AddCollectAmt	= t2.AddCollectAmt,
        OACDefaultPartitionCode	= t2.OACDefaultPartitionCode,
        OACCityCode	= t2.OACCityCode,
        OACAcctCode	= t2.OACAcctCode,
        NonRefFeeCurrCode	= t2.NonRefFeeCurrCode,
        NonRefFeeAmt	= t2.NonRefFeeAmt,
        OBFeeDescText	= t2.OBFeeDescText,
        OBFeePricingCode	= t2.OBFeePricingCode,
        OBFeeWaiverCode	= t2.OBFeeWaiverCode,
        OBFeeTotalCurrCode	= t2.OBFeeTotalCurrCode,
        OBFeeTotal	= t2.OBFeeTotal,
        OBFeeTotalUSD	= t2.OBFeeTotalUSD,
        PricedPassengerType	= t2.PricedPassengerType
          
  from	TktDocument t1
        inner join temp_TktDocument t2 on t1.PrimaryDocNbr = t2.PrimaryDocNbr
          and t1.VCRCreateDate = t2.VCRCreateDate
          and t1.Add1ExchgTktData = t2.Add1ExchgTktData
        
        
    PRINT char(13) + char(13)
    PRINT 'Appending rows to TktDocument' + char(13)
    
    insert TktDocument
    select *
    from   temp_TktDocument t1
    where  not exists (
      select 1
      from   TktDocument _t1
      where  _t1.PrimaryDocNbr = t1.PrimaryDocNbr
             and _t1.VCRCreateDate = t1.VCRCreateDate
             and _t1.Add1ExchgTktData = t1.Add1ExchgTktData
    )
END;
GO

