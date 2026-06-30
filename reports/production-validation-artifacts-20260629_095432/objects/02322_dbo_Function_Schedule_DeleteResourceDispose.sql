-- ─── FUNCTION: schedule_deleteresourcedispose ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteresourcedispose(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourcedispose(
    userno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    resourceno integer;
BEGIN


	SELECT ResourceNo = ResourceNo 
	FROM ScheduleResourcesDispose
	WHERE DisposeNo = DisposeNo;
	
	DELETE FROM ScheduleResourcesDispose
	WHERE DisposeNo = DisposeNo
	
	UPDATE ScheduleResources
	SET
		IsDisposed = FALSE,
		ModUserNo = schedule_deleteresourcedispose.userno,
		ModDate = NOW()
	WHERE ResourceNo = ResourceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
