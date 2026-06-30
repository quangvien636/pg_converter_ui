-- ─── FUNCTION: schedule_getresourcerepaircheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcerepaircheck();
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepaircheck(
) RETURNS TABLE(
    cnt text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT COUNT(ResourceNo) AS CNT 
	FROM ScheduleResourcesRepair
	WHERE ResourceNo = ResourceNo
	AND Status <> 'F';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
