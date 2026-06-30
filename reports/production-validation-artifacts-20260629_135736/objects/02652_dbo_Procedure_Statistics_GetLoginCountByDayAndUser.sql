-- ─── PROCEDURE→FUNCTION: statistics_getlogincountbydayanduser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.statistics_getlogincountbydayanduser(date, integer);
CREATE OR REPLACE FUNCTION public.statistics_getlogincountbydayanduser(
    IN date date,
    IN rankcount integer
) RETURNS SETOF record
AS $function$
DECLARE
    _date character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	_Date := CONVERT(VARCHAR, Date, 112);
	RETURN QUERY
	SELECT TOP (RankCount) UserNo, COUNT(*) AS LoginCount
	FROM Center_LoginLogs
	WHERE CONVERT(VARCHAR, LoginDate, 112) = _Date
	GROUP BY UserNo
	ORDER BY LoginCount DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
