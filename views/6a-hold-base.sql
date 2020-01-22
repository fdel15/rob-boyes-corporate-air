IF OBJECT_ID('dbo.v_hold_base') is NOT NULL
	DROP VIEW dbo.v_hold_base;
GO

CREATE VIEW dbo.v_hold_base AS

  SELECT  DISTINCT
          getdate() as Report_Run_Date,
          rf.SERVICESTARTDATE,
          rf.FLIGHTNBR,
          rf.SERVICESTARTCITY,
          rf.SERVICEENDCITY,
          rf.PNRLOCATORID,
          rf.PNRCREATEDATE,
          rf.CurrentSegmentStatusCode,
          rf.PreviousSegmentStatusCode,
          rf.HistoryActionCodeId,
          rf.ChangeSegmentStatusIndicator,
          rf.CLASSOFSERVICE,
          rf.SEGMENTNBR,
          rp.NAMEFIRST + '/' + rp.NAMELAST as Pax_Name

  FROM      dbo.ResFlight rf
            LEFT OUTER JOIN dbo.TKTDOCUMENT td ON td.PNRLOCATORID = rf.PNRLOCATORID
                                              AND td.PNRCREATEDATE = rf.PNRCREATEDATE

            INNER JOIN dbo.respassenger rp on rp.pnrlocatorid = rf.pnrlocatorid
                                           and rp.pnrcreatedate = rf.pnrcreatedate

  WHERE   td.SOURCESYSTEMID = 'FC' 
          and rf.PNRCREATEDATE > '2019-11-19'
          and rf.INTRAPNRSETNBR = 0
          and rp.intrapnrsetnbr = 0
		  and td.PRIMARYDOCNBR IS NULL
GO
