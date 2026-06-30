-- ─── PROCEDURE→FUNCTION: statistics_getaccessbyapplicationanduser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.statistics_getaccessbyapplicationanduser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.statistics_getaccessbyapplicationanduser(
    IN year integer,
    IN applicationno integer,
    IN rankcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT TOP (RankCount) UserNo, COUNT(*) AS AccessCount
	FROM Center_AccessLogs
	WHERE ApplicationNo = statistics_getaccessbyapplicationanduser.applicationno AND DATEPART(YEAR, AccessDate) = statistics_getaccessbyapplicationanduser.year
	GROUP BY UserNo
	ORDER BY AccessCount DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
