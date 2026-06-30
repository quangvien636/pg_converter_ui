-- ─── FUNCTION: schedule_getscheduleuds ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getscheduleuds(date);
CREATE OR REPLACE FUNCTION public.schedule_getscheduleuds(
    p_date date
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT s.*
	FROM ScheduleContentUds S 
	WHERE s.StartDate >= schedule_getscheduleuds.p_date;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
