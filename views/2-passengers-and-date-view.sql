IF OBJECT_ID('dbo.v_passengers_and_date') is NOT NULL
	DROP VIEW dbo.v_passengers_and_date;
GO

CREATE VIEW dbo.v_passengers_and_date AS

SELECT	top 200000
		dbo.ACSPaxFlight.ServiceStartDate,
		dbo.ACSPaxFlight.FltNbr,
		dbo.ACSPaxFlight.PaxPNROrigin,
		dbo.ACSPaxFlight.PaxPNRDest,
		count(dbo.ACSPaxFlight.NameLast) AS CountOfNameLast

FROM	dbo.ACSPaxFlight

--WHERE	dbo.ACSPaxFlight.AirlineCode ='FC'
--		and dbo.ACSPaxFlight.OnBrdInd = 'Y'
--		and dbo.ACSPaxFlight.PaxThruInd = 'N'

GROUP BY dbo.ACSPaxFlight.ServiceStartDate, dbo.ACSPaxFlight.FltNbr, dbo.ACSPaxFlight.PaxPNROrigin, dbo.ACSPaxFlight.PaxPNRDest, dbo.ACSPaxFlight.AirlineCode, dbo.ACSPaxFlight.OnBrdInd, dbo.ACSPaxFlight.PaxThruInd

HAVING (((dbo.ACSPaxFlight.AirlineCode) = 'FC') and ((dbo.ACSPaxFlight.OnBrdInd)='Y') AND ((dbo.ACSPaxFlight.PaxThruInd)='N'))

ORDER BY dbo.ACSPaxFlight.ServiceStartDate, dbo.ACSPaxFlight.FltNbr, dbo.ACSPaxFlight.PaxPNROrigin, dbo.ACSPaxFlight.PaxPNRDest;
GO

