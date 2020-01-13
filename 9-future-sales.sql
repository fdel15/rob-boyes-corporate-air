IF OBJECT_ID('dbo.v_future_sales') is NOT NULL
	DROP VIEW dbo.v_future_sales;
GO

CREATE VIEW dbo.v_future_sales AS


SELECT  TOP 10000
		tc.PnrLocatorId as PnrLocatorId,
        td.CustomerFullName as Pax_Name,
        tc.ServiceStartDate as TravelDate,
        tc.MarketingFlightNbr as FlightNumber,
        tc.ServiceStartCity as DepartingAirport,
        tc.ServiceEndCity as ArrivingAirport,
        count(*) as TotalOfTicketsPurchased


FROM    dbo.tktCoupon tc
        inner join dbo.tktDocument td on tc.PrimaryDocNbr = td.PrimaryDocNbr
          and tc.PnrLocatorId = td.PnrLocatorId
          and td.PnrCreateDate = tc.PnrCreateDate

WHERE   td.SourceSystemId = 'FC'
        and tc.ServiceStartDate > cast(getdate() as date)

GROUP BY tc.PnrLocatorId, td.CustomerFullName, tc.ServiceStartDate, tc.MarketingFlightNbr,
         tc.ServiceStartCity, tc.ServiceEndCity

ORDER BY tc.ServiceStartDate, tc.MarketingFlightNbr
GO
