-- ─── FUNCTION: workingtime_absent ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_absent(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_absent(
    p_from integer,
    p_to integer,
    p_uid integer
) RETURNS TABLE(
    workingdayc text
)
AS $function$
BEGIN


	RETURN QUERY
	select c.WorkingDayC from WorkingTime_Times c 
	where c.UserNo = workingtime_absent.p_uid and c.WorkingDayC between p_From and p_To;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
