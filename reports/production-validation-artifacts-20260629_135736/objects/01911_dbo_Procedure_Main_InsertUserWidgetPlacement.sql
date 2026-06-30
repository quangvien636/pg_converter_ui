-- ─── PROCEDURE→FUNCTION: main_insertuserwidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.main_insertuserwidgetplacement(integer, timestamp without time zone, integer, integer, character varying, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_insertuserwidgetplacement(
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN boardno integer,
    IN typeno integer,
    IN widgetdata character varying,
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


	INSERT INTO Main_UserWidgetPlacements (ModUserNo, ModDate, BoardNo, TypeNo, WidgetData,
		Left, Top, Width, Height, ZIndex)
	VALUES (ModUserNo, ModDate, BoardNo, TypeNo, WidgetData, Left, Top, Width, Height, ZIndex)
	

	PlaceNo := lastval();
	RETURN QUERY
	SELECT PlaceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
