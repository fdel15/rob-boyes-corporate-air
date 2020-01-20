IF OBJECT_ID('dbo.v_daily_ticket_sales') is NOT NULL
	DROP VIEW dbo.v_daily_ticket_sales;
GO

CREATE VIEW dbo.v_daily_ticket_sales AS

SELECT  TOP 200000
        cast(getdate() as date) as Report_Run_Date,
        td.PrimaryDocNbr as PrimaryDocNbr,
        td.PnrLocatorId as PnrLocatorId,
        td.PnrCreateDate as PnrCreateDate,
        tx.TaxCode as TaxCode,
        isnull(td.PassengerType, 'ADT') as Pax_Type,
        cast(td.TotalDocAmt as decimal(8,2)) as TotalDocAmt,
        cast (SUM(tx.TaxAmt) as decimal(8,2)) as Total_Tax

FROM    dbo.tktDocument td
        LEFT JOIN dbo.tktTax tx on td.PrimaryDocNbr = tx.PrimaryDocNbr 
                                and td.PnrLocatorId = tx.PnrLocatorId
                                and td.PnrCreateDate = tx.PnrCreateDate

WHERE   td.SourceSystemId = 'FC'
        and td.VcrCreateDate > cast(getdate() - 1 as date) 
        
GROUP BY  td.PrimaryDocNbr,
          td.PnrLocatorId,
          td.PnrCreateDate,
          tx.TaxCode,
          td.PassengerType,td.TotalDocAmt

ORDER BY  td.PnrLocatorId, td.PrimaryDocNbr
GO
