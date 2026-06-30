-- ─── PROCEDURE→FUNCTION: main_insertwidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_insertwidgetplacement(integer, timestamp without time zone, integer, integer, boolean, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_insertwidgetplacement(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN widgetno integer,
    IN boardno integer,
    IN isfixed boolean,
    IN left integer,
    IN top integer,
    IN width integer,
    IN height integer,
    IN zindex integer
) RETURNS SETOF record
AS $function$
DECLARE
    placeno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Main_WidgetPlacements (ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top, Width, Height, ZIndex)
	VALUES (ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top, Width, Height, ZIndex)
	

	PlaceNo := lastval();
	RETURN QUERY
	SELECT PlaceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
