-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtimeworktime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtimeworktime(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtimeworktime(
    IN worktimeno integer
) RETURNS SETOF record
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
