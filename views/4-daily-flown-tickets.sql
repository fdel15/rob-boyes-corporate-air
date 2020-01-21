IF OBJECT_ID('dbo.v_daily_flown_tickets') is NOT NULL
	DROP VIEW dbo.v_daily_flown_tickets;
GO

CREATE VIEW dbo.v_daily_flown_tickets AS

SELECT  TOP 200000
		cast(getdate() as date) as Report_Run_Date,
        tc.ServiceStartDate,
        tc.MarketingAirlineCode,
        tc.MarketingFlightNbr,
        tc.ServiceStartCity as BookedBoardPoint,
        tc.ServiceEndCity as BookedOffPoint,
        tc.PNRLocatorId,
        tc.PrimaryDocNbr,
        tc.CouponSeqNbr,
        tc.CouponStatus,
        --tc.CouponUsageCode column name does not exist,
        tc.PreviousCouponStatusCode,
		tc.FlownFlightNbr,
        tc.FlownServiceStartDate,
        tc.FlownServiceStartCity,
        tc.FlownServiceEndCity,
        td.CustomerFullName

FROM    dbo.tktCoupon tc
        inner join dbo.tktDocument td on tc.PrimaryDocNbr = td.PrimaryDocNbr

WHERE   td.SourceSystemID = 'FC'
        and isnull(tc.FlownServiceStartDate, tc.ServiceStartDate) = cast(getdate() - 1 as date)
        and (tc.MarketingAirlineCode = 'FC' or tc.OperatingAirlineCode = 'FC')
        and not exists (
          SELECT  1
          FROM    dbo.tktDocument _td
          WHERE   _td.SourceSystemID = 'FC'
                  and _td.DocTypeCode = 'EMD'
                  and tc.PrimaryDocNbr = _td.PrimaryDocNbr
        )

ORDER BY 1,2,3,4,5,6,7,8,9
GO
