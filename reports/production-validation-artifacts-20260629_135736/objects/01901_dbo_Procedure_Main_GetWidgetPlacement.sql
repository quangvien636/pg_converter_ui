-- ─── PROCEDURE→FUNCTION: main_getwidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_getwidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_getwidgetplacement(
    IN widgetno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT P.PlaceNo, P.ModUserNo, P.ModDate, P.WidgetNo, P.BoardNo, P.Left, P.Top,
		W.Name AS WidgetName, W.Width AS WidgetWidth, W.Height AS WidgetHeight, W.ControlUrl
	FROM Main_WidgetPlacements P
	INNER JOIN Main_Widgets W ON W.WidgetNo = P.WidgetNo
	WHERE P.WidgetNo = main_getwidgetplacement.widgetno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
