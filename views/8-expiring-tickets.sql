IF OBJECT_ID('dbo.v_expiring_tickets') is NOT NULL
	DROP VIEW dbo.v_expiring_tickets;
GO

CREATE VIEW dbo.v_expiring_tickets AS


	SELECT  TOP 200000
			*
	
	FROM	v_expiring_tickets_base

	ORDER BY Current_Origin, Ticket_Expiry_Date, Current_Destination

GO
