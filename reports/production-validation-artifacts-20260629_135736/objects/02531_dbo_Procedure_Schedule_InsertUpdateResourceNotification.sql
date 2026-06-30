-- ─── PROCEDURE→FUNCTION: schedule_insertupdateresourcenotification ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertupdateresourcenotification(integer, xml);
CREATE OR REPLACE FUNCTION public.schedule_insertupdateresourcenotification(
    IN resourceno integer,
    IN strxml xml
) RETURNS void
AS $function$
DECLARE
    dochandle integer;
BEGIN


	-- Create an internal representation of the XML document.  
	EXEC sp_xml_preparedocument docHandle OUTPUT, StrXML   
	CREATE TEMP TABLE tb AS SELECT * FROM OPENXML (docHandle, '/root/ResourceNotification')  WITH (NotificationNo  int, ResourceNo int, NotificationType varchar(100), AlarmTime int)

	-- update
	if(exists(select 1 from ScheduleResourceNotifications where ResourceNo = schedule_insertupdateresourcenotification.resourceno))
	begin
		-- DELETE FROM delete ScheduleResourceNotifications where ResourceNo = ResourceNo

		-- add new data;
		insert into ScheduleResourceNotifications(ResourceNo,NotificationType,AlarmTime)
		select ResourceNo , NotificationType, AlarmTime
		from tb
	END;
	else -- INSERT INTO begin ;
		insert into ScheduleResourceNotifications(ResourceNo,NotificationType,AlarmTime)
		select ResourceNo , NotificationType, AlarmTime
		from tb
	END;
	drop table tb
	PERFORM sp_xml_removedocument(docHandle);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
