-- ─── PROCEDURE→FUNCTION: schedule_deletenotificationservice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletenotificationservice(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.schedule_deletenotificationservice(
    IN companyno integer,
    IN projectcode character varying,
    IN connectionkey integer
) RETURNS void
AS $function$
BEGIN

--- DELETE FROM old
	--DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo in (select  NotificationNo from  Center_NotificationService where  ProjectCode = 'Schedule' and Connectionkey not in (select ScheduleNo from ScheduleContents ) )
	--DELETE FROM Center_NotificationService where  ProjectCode = 'Schedule' and Connectionkey not in (select ScheduleNo from ScheduleContents ) 


	DELETE FROM Center_NotificationService_AlarmDetail where NotificationNo in
	(select  NotificationNo from  Center_NotificationService where CompanyNo = schedule_deletenotificationservice.companyno and ProjectCode = schedule_deletenotificationservice.projectcode and Connectionkey = schedule_deletenotificationservice.connectionkey )

	--DELETE FROM main;
	DELETE FROM Center_NotificationService 
	where NotificationNo in
	(select  NotificationNo from  Center_NotificationService where CompanyNo = schedule_deletenotificationservice.companyno and ProjectCode = schedule_deletenotificationservice.projectcode and Connectionkey = schedule_deletenotificationservice.connectionkey );
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
