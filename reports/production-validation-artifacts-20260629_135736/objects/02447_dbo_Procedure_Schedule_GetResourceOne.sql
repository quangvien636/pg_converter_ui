-- ─── PROCEDURE→FUNCTION: schedule_getresourceone ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourceone(integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourceone(
    IN resourceno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		R.CategoryNo,
		C.Name AS CategoryName,
		R.ResourceNo,
		R.Name,
		R.Enabled,
		R.Description,
		R.BuyGroupNo,
		R.IsReservation,
		R.Type
		,COALESCE(r.IsHidenReg,0) IsHidenReg
		,COALESCE(r.Color,'') Color
	FROM
		ScheduleResources r
		LEFT JOIN ScheduleResourceCategories c ON r.CategoryNo = c.CategoryNo
	WHERE ResourceNo = schedule_getresourceone.resourceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
