-- ─── PROCEDURE→FUNCTION: main_getinitialwidgetplacements ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_getinitialwidgetplacements();
CREATE OR REPLACE FUNCTION public.main_getinitialwidgetplacements(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT P.PlaceNo, P.ModUserNo, P.ModDate, P.WidgetNo, P.IsFixed, P.Left, P.Top, P.Width, P.Height,
		W.Name AS WidgetName, W.ControlUrl
	FROM Main_InitialWidgetPlacements P
	INNER JOIN Main_Widgets W ON W.WidgetNo = P.WidgetNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
