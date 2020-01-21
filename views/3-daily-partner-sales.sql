IF OBJECT_ID('dbo.v_daily_partner_sales') is NOT NULL
	DROP VIEW dbo.v_daily_partner_sales;
GO

CREATE VIEW dbo.v_daily_partner_sales AS

  SELECT  TOP 200000
          *

  FROM    dbo.v_daily_partner_sales_base
      
  ORDER BY 2,3
GO

