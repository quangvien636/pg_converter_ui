-- ─── PROCEDURE→FUNCTION: workingtime_gettypecheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_gettypecheck(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettypecheck(
    IN userno integer,
    IN daycurrent integer
) RETURNS SETOF record
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
