DECLARE @job_name NVARCHAR(128), @description NVARCHAR(512), @schedule_name NVARCHAR(512)

SET @job_name = N'Daily Sabre Import'
SET @description = N'Creates Scheduled Job that will be run daily 4:30AM AEST'
SET @schedule_name = N'Everyday Schedule'


-- Add step to execute SQL:
EXEC  msdb.dbo.sp_add_job  
      @job_name = @job_name,   
      @enabled = 1,   
      @description = @description;


EXEC  msdb.dbo.sp_add_jobstep  
      @job_name = @job_name,   
      @step_name = N'Run Procedure',   
      @subsystem = N'TSQL',   
      @command = 'exec DailySabreImport';

-- https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-add-schedule-transact-sql?view=sql-server-ver15
EXEC  msdb.dbo.sp_add_schedule  
      @schedule_name = @schedule_name,   
      @freq_type = 4,  -- daily start
      @freq_interval = 1, -- run every day
      @active_start_time = '043000'; -- 4:30AM

EXEC  msdb.dbo.sp_attach_schedule  
      @job_name = @job_name, 
      @schedule_name = @schedule_name;


EXEC  msdb.dbo.sp_add_jobserver  
      @job_name = N'MakeDailyJob',  
      @server_name = @@servername;
