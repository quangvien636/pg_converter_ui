-- ─── PROCEDURE→FUNCTION: work_getregularworkgroupfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularworkgroupfiles(integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupfiles(
    IN historyno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FileNo, HistoryNo, Name, Length
	FROM RegularWorkGroupFiles WHERE HistoryNo = work_getregularworkgroupfiles.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
