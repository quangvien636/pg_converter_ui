-- ─── FUNCTION: workingtime_recal ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_recal(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_recal(
    p_uno integer,
    p_start integer,
    p_end integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT T.*
	FROM WorkingTime_Times T 
	where T.TimeType = 3 
	and T.UserNo = workingtime_recal.p_uno AND T.WorkingDayC BETWEEN p_Start AND p_End
	ORDER BY t.CheckTimeFull ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
