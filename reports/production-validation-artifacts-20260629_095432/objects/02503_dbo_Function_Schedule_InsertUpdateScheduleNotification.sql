-- ─── FUNCTION: schedule_insertupdateschedulenotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertupdateschedulenotification(integer, xml);
CREATE OR REPLACE FUNCTION public.schedule_insertupdateschedulenotification(
    scheduleno integer,
    strxml xml
) RETURNS void
AS $function$
DECLARE
    dochandle integer;
BEGIN


	-- Create an internal representation of the XML document.  
	EXEC sp_xml_preparedocument docHandle OUTPUT, StrXML   
	SELECT * into #tb 
	FROM OPENXML (docHandle, '/root/ScheduleNotification')  WITH (NotificationNo  int, ScheduleNo int, NotificationType varchar(100), AlarmTime int)

	-- update
	if(exists(select 1 from ScheduleNotifications where ScheduleNo = schedule_insertupdateschedulenotification.scheduleno))
	begin
		-- DELETE FROM delete ScheduleNotifications where ScheduleNo = ScheduleNo

		-- add new data;
		insert into ScheduleNotifications(ScheduleNo,NotificationType,AlarmTime)
		select ScheduleNo , NotificationType, AlarmTime
		from #tb
	end
	else -- INSERT INTO begin ;
		insert into ScheduleNotifications(ScheduleNo,NotificationType,AlarmTime)
		select ScheduleNo , NotificationType, AlarmTime
		from #tb
	end
	drop table #tb
	EXEC sp_xml_removedocument docHandle;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
