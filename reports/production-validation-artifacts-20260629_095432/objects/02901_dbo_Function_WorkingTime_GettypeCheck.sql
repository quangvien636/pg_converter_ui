-- ─── FUNCTION: workingtime_gettypecheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_gettypecheck(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettypecheck(
    userno integer,
    daycurrent integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT /* TOP 1 */ * FROM WorkingTime_Times
	WHERE UserNo=workingtime_gettypecheck.userno AND WorkingDay=workingtime_gettypecheck.daycurrent
	ORDER BY WorkingNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
