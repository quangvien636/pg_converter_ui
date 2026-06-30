-- ─── FUNCTION: workingtime_getworkingtimeworktime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimeworktime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimeworktime(
    worktimeno integer
) RETURNS SETOF record
-- TODO: replace SETOF record — add RETURNS TABLE(col1 type, col2 type, ...)
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT *
		FROM WorkingTime_WorkTime W
		Where WorkTimeNo= workingtime_getworkingtimeworktime.worktimeno
		ORDER BY WorkStart ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
