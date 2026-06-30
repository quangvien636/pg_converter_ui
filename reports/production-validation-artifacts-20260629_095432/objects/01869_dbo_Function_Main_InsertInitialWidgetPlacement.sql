-- ─── FUNCTION: main_insertinitialwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_insertinitialwidgetplacement(integer, timestamp without time zone, integer, boolean, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_insertinitialwidgetplacement(
    moduserno integer,
    moddate timestamp without time zone,
    widgetno integer,
    isfixed boolean,
    left integer,
    top integer,
    width integer,
    height integer
) RETURNS TABLE(
    moduserno text,
    moddate text,
    widgetno text,
    boardno text,
    isfixed text,
    left text,
    top text,
    width text,
    height text
)
AS $function$
DECLARE
    placeno integer;
BEGIN


	INSERT INTO Main_InitialWidgetPlacements (ModUserNo, ModDate, WidgetNo, IsFixed, Left, Top, Width, Height)
	VALUES (ModUserNo, ModDate, WidgetNo, IsFixed, Left, Top, Width, Height)
	

	SET PlaceNo = lastval()
	
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
