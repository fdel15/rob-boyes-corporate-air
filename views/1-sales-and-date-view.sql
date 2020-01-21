  
IF OBJECT_ID('dbo.v_sales_and_date') is NOT NULL
	DROP VIEW dbo.v_sales_and_date;
GO

CREATE VIEW dbo.v_sales_and_date AS

	SELECT	DISTINCT
			TOP 200000
			tc.PNRLocatorId,
			tc.ServiceStartDate,
			tc.MarketingFlightNbr,
			tc.ServiceStartCity,
			tc.ServiceEndCity,
			td.CustomerFullName as pax_name,
			td.TotalDocAmt,
			tc.CouponStatus

	FROM	dbo.tktcoupon tc
			inner join dbo.tktdocument td on td.primarydocnbr = tc.primarydocnbr

	WHERE	td.SourceSystemId = 'fc'

	ORDER BY tc.servicestartdate, tc.servicestartcity, tc.pnrlocatorid
GO
