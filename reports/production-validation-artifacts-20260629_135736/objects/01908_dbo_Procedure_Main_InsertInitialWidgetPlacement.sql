-- ─── PROCEDURE→FUNCTION: main_insertinitialwidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_insertinitialwidgetplacement(integer, timestamp without time zone, integer, boolean, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_insertinitialwidgetplacement(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN widgetno integer,
    IN isfixed boolean,
    IN left integer,
    IN top integer,
    IN width integer,
    IN height integer
) RETURNS SETOF record
AS $function$
DECLARE
    placeno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Main_InitialWidgetPlacements (ModUserNo, ModDate, WidgetNo, IsFixed, Left, Top, Width, Height)
	VALUES (ModUserNo, ModDate, WidgetNo, IsFixed, Left, Top, Width, Height)
	

	PlaceNo := lastval();
	RETURN QUERY
	SELECT PlaceNo
	
	DELETE FROM Main_WidgetPlacements WHERE WidgetNo = main_insertinitialwidgetplacement.widgetno
	
	INSERT INTO Main_WidgetPlacements (ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top, Width, Height)
	RETURN QUERY
	SELECT ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top, Width, Height
	FROM Main_DashBoards;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
