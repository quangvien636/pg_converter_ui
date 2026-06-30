-- ─── FUNCTION: schedule_insertupdateresourcenotification ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertupdateresourcenotification(integer, xml);
CREATE OR REPLACE FUNCTION public.schedule_insertupdateresourcenotification(
    resourceno integer,
    strxml xml
) RETURNS void
AS $function$
DECLARE
    dochandle integer;
BEGIN


	-- Create an internal representation of the XML document.  
	EXEC sp_xml_preparedocument docHandle OUTPUT, StrXML   
	SELECT * into #tb 
	FROM OPENXML (docHandle, '/root/ResourceNotification')  WITH (NotificationNo  int, ResourceNo int, NotificationType varchar(100), AlarmTime int)

	-- update
	if(exists(select 1 from ScheduleResourceNotifications where ResourceNo = schedule_insertupdateresourcenotification.resourceno))
	begin
		-- DELETE FROM delete ScheduleResourceNotifications where ResourceNo = ResourceNo

		-- add new data;
		insert into ScheduleResourceNotifications(ResourceNo,NotificationType,AlarmTime)
		select ResourceNo , NotificationType, AlarmTime
		from #tb
	end
	else -- INSERT INTO begin ;
		insert into ScheduleResourceNotifications(ResourceNo,NotificationType,AlarmTime)
		select ResourceNo , NotificationType, AlarmTime
		from #tb
	end
	drop table #tb
	EXEC sp_xml_removedocument docHandle;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
