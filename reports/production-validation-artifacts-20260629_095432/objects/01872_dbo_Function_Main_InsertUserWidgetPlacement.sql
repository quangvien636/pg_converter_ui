-- ─── FUNCTION: main_insertuserwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_insertuserwidgetplacement(integer, timestamp without time zone, integer, integer, character varying, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_insertuserwidgetplacement(
    moduserno integer,
    moddate timestamp without time zone,
    boardno integer,
    typeno integer,
    widgetdata character varying,
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


	INSERT INTO Main_UserWidgetPlacements (ModUserNo, ModDate, BoardNo, TypeNo, WidgetData,
		Left, Top, Width, Height, ZIndex)
	VALUES (ModUserNo, ModDate, BoardNo, TypeNo, WidgetData, Left, Top, Width, Height, ZIndex)
	

	SET PlaceNo = lastval()
	
	RETURN QUERY
	SELECT PlaceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
