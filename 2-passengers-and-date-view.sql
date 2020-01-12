-- Passengers x Date

-- Caveats:
--  1. To use order by in a VIEW we need to limit the number of records the query returns. Currently it is set to 10_000 records. Does this work for you? Is 10_000 enough?
--  2. Another option would be to move the order by clause from the VIEW to the query the end user writes in MS Access or Excel. This would allow us to return all records in the query. I'm not sure if that works for you.
IF OBJECT_ID('dbo.passengers_and_date') is NOT NULL
	DROP VIEW dbo.passengers_and_date;
GO

CREATE VIEW dbo.passengers_and_date AS

SELECT	top 10000
		dbo.ACSPaxFlight.ServiceStartDate,
		dbo.ACSPaxFlight.FltNbr,
		dbo.ACSPaxFlight.PaxPNROrigin,
		dbo.ACSPaxFlight.PaxPNRDest,
		count(dbo.ACSPaxFlight.NameLast) AS CountOfNameLast

FROM	dbo.ACSPaxFlight

WHERE	dbo.ACSPaxFlight.AirlineCode ='FC'
		and dbo.ACSPaxFlight.OnBrdInd = 'Y'
		and dbo.ACSPaxFlight.PaxThruInd = 'N'

GROUP BY dbo.ACSPaxFlight.ServiceStartDate, dbo.ACSPaxFlight.FltNbr, dbo.ACSPaxFlight.PaxPNROrigin, dbo.ACSPaxFlight.PaxPNRDest, dbo.ACSPaxFlight.AirlineCode, dbo.ACSPaxFlight.OnBrdInd, dbo.ACSPaxFlight.PaxThruInd

ORDER BY dbo.ACSPaxFlight.ServiceStartDate, dbo.ACSPaxFlight.FltNbr, dbo.ACSPaxFlight.PaxPNROrigin, dbo.ACSPaxFlight.PaxPNRDest;
GO

