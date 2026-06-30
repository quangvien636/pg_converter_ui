-- ─── PROCEDURE→FUNCTION: schedule_getresourcenotificationtype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcenotificationtype();
CREATE OR REPLACE FUNCTION public.schedule_getresourcenotificationtype(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	, NotificationTypeName nvarchar(1000))
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsEmail = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mail','Email')
	END;
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsAlarmi = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('crewchat','CrewChat')
	END;
	/*
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsPC = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('pc','PC')
	END;
	*/
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsMobile = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mobile','Mobile')
	END;
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsWebAlarm = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mailplugwebhook','Web')
	END;
	RETURN QUERY
	select*from MyTable;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
