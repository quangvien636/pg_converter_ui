-- ─── FUNCTION: workingtime_gettimecheckin ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_gettimecheckin(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimecheckin(
    p_userno integer,
    p_wkstart integer,
    p_wkend integer,
    p_workingno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT /* TOP 1 */  CheckTime, TimeOffset, WorkingDay
	FROM WorkingTime_Times 
	WHERE TimeType = 1  AND RegUserNo = workingtime_gettimecheckin.p_userno AND WorkingDay BETWEEN p_WkStart AND p_WkEnd AND WorkingNo < workingtime_gettimecheckin.p_workingno
	and COALESCE(status,0) != 1
	AND WorkingNo > COALESCE((
							SELECT /* TOP 1 */ WorkingNo FROM WorkingTime_Times WHERE TimeType <> 1 AND WorkingNo < workingtime_gettimecheckin.p_workingno 
							AND UserNo = workingtime_gettimecheckin.p_userno  
						    ORDER BY COALESCE(CheckTimeFull,'2019-06-02') DESC),0)
	ORDER BY COALESCE(CheckTimeFull,'2019-06-02') ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
