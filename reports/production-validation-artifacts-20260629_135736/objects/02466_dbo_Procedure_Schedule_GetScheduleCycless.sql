-- ─── PROCEDURE→FUNCTION: schedule_getschedulecycless ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getschedulecycless();
CREATE OR REPLACE FUNCTION public.schedule_getschedulecycless(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT c.CycleNo
		, c.RegDate
		, c.Name
		, COALESCE(c.NameEn,c.Name) NameEn
		, COALESCE(c.NameJp,c.Name) NameJp
		, COALESCE(c.NameCh,c.Name) NameCh
		, COALESCE(c.NameVn,c.Name) NameVn
		, SortOrder
	FROM ScheduleCycles c order by c.SortOrder;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
