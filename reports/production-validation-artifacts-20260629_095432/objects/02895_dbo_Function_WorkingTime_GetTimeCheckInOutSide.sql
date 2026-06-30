-- ─── FUNCTION: workingtime_gettimecheckinoutside ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_gettimecheckinoutside(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimecheckinoutside(
    p_userno integer,
    p_day integer,
    p_workingno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT /* TOP 1 */  CheckTime, TimeOffset, WorkingDay, CheckTimeC, CheckTimeFull
	FROM WorkingTime_Times 
	WHERE TimeType = 2  AND RegUserNo = workingtime_gettimecheckinoutside.p_userno AND COALESCE(WorkingDayC,WorkingDay) = workingtime_gettimecheckinoutside.p_day AND WorkingNo < workingtime_gettimecheckinoutside.p_workingno
	and COALESCE(status,0) != 1
	AND WorkingNo > COALESCE((
							SELECT /* TOP 1 */ WorkingNo FROM WorkingTime_Times WHERE TimeType <> 2 AND WorkingNo < workingtime_gettimecheckinoutside.p_workingno 
							AND UserNo = workingtime_gettimecheckinoutside.p_userno  
						    ORDER BY WorkingNo DESC),0)
	ORDER BY WorkingNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
