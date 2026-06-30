-- ─── PROCEDURE→FUNCTION: main_getwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_getwidget(integer);
CREATE OR REPLACE FUNCTION public.main_getwidget(
    IN widgetno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT WidgetNo, ModUserNo, ModDate, Name, CategoryNo, Width, Height, ControlUrl, IsCompany, Enabled
	FROM Main_Widgets
	WHERE WidgetNo = main_getwidget.widgetno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
