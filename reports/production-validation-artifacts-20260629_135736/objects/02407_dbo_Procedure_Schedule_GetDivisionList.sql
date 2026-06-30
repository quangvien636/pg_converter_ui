-- ─── PROCEDURE→FUNCTION: schedule_getdivisionlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getdivisionlist();
CREATE OR REPLACE FUNCTION public.schedule_getdivisionlist(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		DivisionNo,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		Name,
		COALESCE(NameEn,'') AS NameEn,
		COALESCE(NameJp,'') AS NameJp,
		COALESCE(NameCh,'') AS NameCh,
		COALESCE(NameVn,'') AS NameVn,
		Color,
		coalesce(SortOrder,0) as SortOrder
	FROM ScheduleDivisions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
