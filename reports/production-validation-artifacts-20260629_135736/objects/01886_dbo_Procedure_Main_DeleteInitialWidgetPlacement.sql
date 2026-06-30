-- ─── PROCEDURE→FUNCTION: main_deleteinitialwidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_deleteinitialwidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_deleteinitialwidgetplacement(
    IN placeno integer
) RETURNS SETOF record
AS $function$
DECLARE
    widgetno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	SELECT  INTO  FROM Main_InitialWidgetPlacements
	WHERE PlaceNo = main_deleteinitialwidgetplacement.placeno

	DELETE FROM Main_InitialWidgetPlacements WHERE PlaceNo = main_deleteinitialwidgetplacement.placeno
	
	DELETE FROM Main_WidgetPlacements WHERE WidgetNo = WidgetNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
