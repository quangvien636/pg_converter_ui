-- ─── PROCEDURE→FUNCTION: schedule_insertupdateschedulenotification ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertupdateschedulenotification(integer, xml);
CREATE OR REPLACE FUNCTION public.schedule_insertupdateschedulenotification(
    IN scheduleno integer,
    IN strxml xml
) RETURNS void
AS $function$
DECLARE
    dochandle integer;
BEGIN


	-- Create an internal representation of the XML document.  
	EXEC sp_xml_preparedocument docHandle OUTPUT, StrXML   
	CREATE TEMP TABLE tb AS SELECT * FROM OPENXML (docHandle, '/root/ScheduleNotification')  WITH (NotificationNo  int, ScheduleNo int, NotificationType varchar(100), AlarmTime int)

	-- update
	if(exists(select 1 from ScheduleNotifications where ScheduleNo = schedule_insertupdateschedulenotification.scheduleno))
	begin
		-- DELETE FROM delete ScheduleNotifications where ScheduleNo = ScheduleNo

		-- add new data;
		insert into ScheduleNotifications(ScheduleNo,NotificationType,AlarmTime)
		select ScheduleNo , NotificationType, AlarmTime
		from tb
	END;
	else -- INSERT INTO begin ;
		insert into ScheduleNotifications(ScheduleNo,NotificationType,AlarmTime)
		select ScheduleNo , NotificationType, AlarmTime
		from tb
	END;
	drop table tb
	PERFORM sp_xml_removedocument(docHandle);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
