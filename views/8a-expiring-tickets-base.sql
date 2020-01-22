IF OBJECT_ID('dbo.v_expiring_tickets_base') is NOT NULL
	DROP VIEW dbo.v_expiring_tickets_base;
GO

CREATE VIEW dbo.v_expiring_tickets_base AS

	SELECT	DISTINCT
					tc.vcrcreatedate as Original_Ticketing_Date,
					cast(cast(tc.vcrcreatedate as datetime) + 365 as date) as Ticket_Expiry_Date,
					tc.couponseqnbr as Coupon_Seq_Nbr,
					tc.Servicestartcity as Current_Origin,
					tc.serviceendcity as Current_Destination,
					tc.pnrlocatorid as Booking_Locator,
					td.customerfullname as Pax_Name

	FROM		dbo.tktcoupon tc
					inner join dbo.tktDocument td on tc.primarydocnbr = td.primarydocnbr
						and tc.pnrlocatorid = td.pnrlocatorid
						and td.pnrcreatedate = tc.pnrcreatedate

	WHERE		td.sourcesystemid = 'fc'
					and tc.couponstatus = 'ok'
					and cast(cast(tc.vcrcreatedate as datetime) + 365 as date)  > cast(getdate() as date)
					and cast(cast(tc.vcrcreatedate as datetime) + 365 as date) < cast(getdate() + 7 as date) 
GO

