-- ─── FUNCTION: schedule_getnotificationtype ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getnotificationtype();
CREATE OR REPLACE FUNCTION public.schedule_getnotificationtype(
) RETURNS TABLE(
    1 text
)
AS $function$
BEGIN


	if(exists( select 1 from ScheduleAlarmSetting where IsEmail = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mail','Email')
	end
	if(exists( select 1 from ScheduleAlarmSetting where IsAlarmi = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('crewchat','CrewChat')
	end
	/*
	if(exists( select 1 from ScheduleAlarmSetting where IsPC = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('pc','PC')
	end*/
	if(exists( select 1 from ScheduleAlarmSetting where IsMobile = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mobile','Mobile')
	end
	if(exists( select 1 from ScheduleAlarmSetting where IsWebAlarm = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mailplugwebhook','Web')
	end
	RETURN QUERY
	select*from MyTable;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
