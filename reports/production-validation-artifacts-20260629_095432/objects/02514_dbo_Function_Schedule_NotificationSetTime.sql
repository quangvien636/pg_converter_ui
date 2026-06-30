-- ─── FUNCTION: schedule_notificationsettime ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_notificationsettime(integer, character varying, integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_notificationsettime(
    companyno integer,
    projectcode character varying,
    connectionkey integer,
    startdate timestamp without time zone,
    enddate timestamp without time zone
) RETURNS void
AS $function$
DECLARE
    strtimeold character varying;
BEGIN



	select NotificationNo = NotificationNo, strTimeold = convert(varchar, StartDate, 23) from Center_NotificationService 
	where CompanyNo = schedule_notificationsettime.companyno and ProjectCode = schedule_notificationsettime.projectcode and Connectionkey = schedule_notificationsettime.connectionkey

	if(NotificationNo > 0)
	begin
		-- update detail;
		update Center_NotificationService_AlarmDetail set Content_Json = REPLACE(Content_Json, strTimeold, convert(varchar, StartDate, 23))
		where NotificationNo = NotificationNo and	AlarmCode = 'mail'

		-- update detail;
		update Center_NotificationService_AlarmDetail set Content_Json = REPLACE(Content_Json, strTimeold, convert(varchar, StartDate, 23))
		where NotificationNo = NotificationNo and	AlarmCode = 'crewchat'

		--update main;
		Update Center_NotificationService set StartDate = schedule_notificationsettime.startdate,  EndDate = schedule_notificationsettime.enddate
		where NotificationNo = NotificationNo
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
