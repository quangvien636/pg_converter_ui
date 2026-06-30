-- ─── FUNCTION: main_getuserwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getuserwidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_getuserwidgetplacement(
    placeno integer
) RETURNS TABLE(
    placeno text,
    moduserno text,
    moddate text,
    boardno text,
    typeno text,
    widgetdata text,
    left text,
    top text,
    width text,
    height text,
    zindex text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT PlaceNo, ModUserNo, ModDate, BoardNo, TypeNo,
		WidgetData, Left, Top, Width, Height, ZIndex
	FROM Main_UserWidgetPlacements
	WHERE PlaceNo = main_getuserwidgetplacement.placeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
