-- ─── FUNCTION: workingtime_countlatebyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_countlatebyuser(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_countlatebyuser(
    p_uno integer,
    p_wkd integer
) RETURNS TABLE(
    late text
)
AS $function$
BEGIN


	
RETURN QUERY
Select 	COALESCE(Sum( CASE WHEN (t.CheckTimeC >  (cast(LEFT(t.StarWorking,2) as int)*60+ cast(SUBSTRING(t.StarWorking,3,2) as int))) AND t.TimeType = 1 THEN 1 ELSE 0 END),0) as Late

from WorkingTime_Times t 
join Organization_Users u	on t.UserNo = u.UserNo
join Organization_BelongToDepartment b on u.UserNo = B.UserNo
where t.WorkingdayC = workingtime_countlatebyuser.p_wkd
and b.UserNo = workingtime_countlatebyuser.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
