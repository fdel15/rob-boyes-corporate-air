IF OBJECT_ID('dbo.v_daily_summary_by_route') is NOT NULL
	DROP VIEW dbo.v_daily_summary_by_route;
GO

CREATE VIEW dbo.v_daily_summary_by_route AS

  SELECT  TOP 10000
          *

  FROM    dbo.v_daily_summary_by_route_base

  ORDER BY Report_Run_Date, Origin
GO

