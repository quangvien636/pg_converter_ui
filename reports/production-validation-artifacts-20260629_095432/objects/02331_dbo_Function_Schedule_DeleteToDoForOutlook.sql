-- ─── FUNCTION: schedule_deletetodoforoutlook ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletetodoforoutlook();
CREATE OR REPLACE FUNCTION public.schedule_deletetodoforoutlook(
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    todono integer;
BEGIN


	SELECT ToDoNo = ToDoNo FROM ScheduleToDosOutlook 
	WHERE OutlookEntryID = OutlookEntryID
	
	DELETE FROM ScheduleToDosOutlook WHERE OutlookEntryID = OutlookEntryID;
	DELETE FROM ScheduleToDos WHERE ToDoNo = ToDoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
