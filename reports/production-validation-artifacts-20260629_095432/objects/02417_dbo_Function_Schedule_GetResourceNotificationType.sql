-- ─── FUNCTION: schedule_getresourcenotificationtype ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcenotificationtype();
CREATE OR REPLACE FUNCTION public.schedule_getresourcenotificationtype(
) RETURNS TABLE(
    1 text
)
AS $function$
BEGIN


	if(exists( select 1 from ScheduleResourceAlarmSetting where IsEmail = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mail','Email')
	end
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsAlarmi = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('crewchat','CrewChat')
	end
	/*
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsPC = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('pc','PC')
	end
	*/
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsMobile = TRUE))
	begin;
		insert into MyTable(NotificationTypeNo, NotificationTypeName)
		values('mobile','Mobile')
	end
	if(exists( select 1 from ScheduleResourceAlarmSetting where IsWebAlarm = TRUE))
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
