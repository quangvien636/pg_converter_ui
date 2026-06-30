-- ─── PROCEDURE→FUNCTION: schedule_getscheduledivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getscheduledivisions();
CREATE OR REPLACE FUNCTION public.schedule_getscheduledivisions(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, COALESCE(NameEn,Name) NameEn, COALESCE(NameJp,Name) NameJp, COALESCE(NameCh,Name) NameCh, COALESCE(NameVn,Name) NameVn, Color
	FROM ScheduleDivisions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
