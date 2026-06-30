-- ─── FUNCTION: main_insertwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_insertwidgetplacement(integer, timestamp without time zone, integer, integer, boolean, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_insertwidgetplacement(
    moduserno integer,
    moddate timestamp without time zone,
    widgetno integer,
    boardno integer,
    isfixed boolean,
    left integer,
    top integer,
    width integer,
    height integer,
    zindex integer
) RETURNS TABLE(
    placeno text
)
AS $function$
DECLARE
    placeno integer;
BEGIN


	INSERT INTO Main_WidgetPlacements (ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top, Width, Height, ZIndex)
	VALUES (ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top, Width, Height, ZIndex)
	

	SET PlaceNo = lastval()
	
	RETURN QUERY
	SELECT PlaceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
