-- ─── FUNCTION: workingtime_countlate ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_countlate(integer);
CREATE OR REPLACE FUNCTION public.workingtime_countlate(
    p_wkd integer
) RETURNS TABLE(
    late text
)
AS $function$
BEGIN


	
RETURN QUERY
Select COALESCE(	Sum( CASE WHEN (t.CheckTimeC >  (cast(LEFT(t.StarWorking,2) as int)*60+ cast(SUBSTRING(t.StarWorking,3,2) as int))) AND t.TimeType = 1 THEN 1 ELSE 0 END),0 )as Late

from WorkingTime_Times t where t.WorkingdayC = workingtime_countlate.p_wkd;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
