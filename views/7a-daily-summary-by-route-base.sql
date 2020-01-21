IF OBJECT_ID('dbo.v_daily_summary_by_route_base') is NOT NULL
	DROP VIEW dbo.v_daily_summary_by_route_base;
GO

CREATE VIEW dbo.v_daily_summary_by_route_base AS

SELECT  DISTINCT
        getdate() as Report_Run_Date,
        tc.ServiceStartCity as Origin,
        tc.ServiceEndCity as Destination,
        count(rf.PnrLocatorId) as Number_of_Bookings,
        sum(cast(td.BaseFareAmt as decimal(8,2)) ) as Summed_Base_Fare

FROM    dbo.tktDocument td
        INNER JOIN dbo.tktcoupon tc on td.pnrlocatorid = tc.pnrlocatorid
                                    and td.pnrcreatedate = tc.pnrcreatedate
                                    and td.PRIMARYDOCNBR = tc.PRIMARYDOCNBR
        INNER JOIN dbo.ResFlight rf ON rf.pnrlocatorid = tc.pnrlocatorid
                                    and rf.servicestartcity = tc.servicestartcity
                                    and rf.pnrcreatedate = tc.pnrcreatedate
                                    and INTRAPNRSETNBR = 0
where   td.sourcesystemid = 'fc'
        --and td.PNRCREATEDATE > cast(getdate() - 10 as date) 
        
group by tc.ServiceStartCity, tc.ServiceEndCity
GO
