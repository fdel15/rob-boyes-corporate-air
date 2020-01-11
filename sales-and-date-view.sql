select	tc.PNRLocatorId,
	tc.ServiceStartDate,
	tc.MarketingFlightNbr,
	tc.ServiceStartCity,
	tc.ServiceEndCity,
	td.CustomerFullName as pax_name,
	td.TotalDocAmt,
	tc.CouponStatus

from	dbo.tktcoupon tc
	inner join dbo.tktdocument td on td.primarydocnbr = tc.primarydocnbr

where	td.SourceSystemId = 'fc'
	and tc.servicestartdate between '2019-12-01' and '2019-12-31'

order by tc.servicestartdate, tc.servicestartcity, tc.pnrlocatorid
