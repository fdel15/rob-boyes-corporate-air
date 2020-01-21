IF OBJECT_ID('dbo.v_daily_partner_sales_base') is NOT NULL
	DROP VIEW dbo.v_daily_partner_sales_base;
GO

CREATE VIEW dbo.v_daily_partner_sales_base AS

	SELECT	DISTINCT
			getdate() as Report_Run_Date,
			case 
				when cast(tc.MarketingFlightnBr as integer) between 0 and 199 then 'Fly FC Booking'  -- How to handle if flight number is three digits, ex: 228? Should it be the same behavior as 0228
				when cast(tc.MarketingFlightnBr as integer) between 1000 and 1999 then 'Fly FC Booking' 
				else 'Corporate Air Booking'
			end as Booking_Partner,
			rf.PnrLocatorId as Pnr_Locator_Id,
			rf.PnrCreateDate reaterateeate_Date,
			isnull(passengertype, 'ADT') as Pax_Type,
			tc.ServiceStartCity as Origin,
			tc.ServiceEndCity as Destination,
			td.CustomerFullName AS PAX_NAME,
			td.PrimaryDocNbr as Ticket,
			tc.CouponSeqNbr as Coupon_Seq,
			tc.ClassOfService as Booking_Class,
			tc.MarketingFlightnBr as Mktg_Flight_Nbr,
			tc.ServiceStartDate as Flight_Date,
			cast(td.BaseFareAmt as decimal(8,2)) as Base_Fare -- changed tc.ProrateBaseFareAmt to td.BaseFareAmt because ProrateBaseFareAmt does not exist in DB

			-- Not sure why the below code is commented out?
			--SELECT MAX(SERVICEENDDATE) FROM CERT_NONFIT_BASE_VIEWS.RESODFLIGHT OD --WHERE OD.PNRLOCATORID = td.PNRLOCATORID
			--AND OD.PNRCREATEDATE = td.PNRCREATEDATE) AS Last_Return_Date,

	FROM	dbo.tktDocument td
			inner join dbo.tktCoupon tc on td.PnrLocatorId = tc.Pnrlocatorid 
				and td.PnrCreateDate = tc.PnrCreateDate
				and td.PrimaryDocNbr = tc.PrimaryDocNbr
			inner join dbo.ResFlight rf ON rf.PnrLocatorId = tc.Pnrlocatorid
				and rf.servicestartcity = tc.servicestartcity
				and rf.PnrCreateDate = tc.PnrCreateDate
				and rf.intrapnrsetnbr = 0

	WHERE td.SourceSystemId = 'fc'
GO
