-- ─── FUNCTION: main_getwidgetplacements ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getwidgetplacements(integer);
CREATE OR REPLACE FUNCTION public.main_getwidgetplacements(
    boardno integer
) RETURNS TABLE(
    placeno text,
    moduserno text,
    moddate text,
    widgetno text,
    boardno text,
    isfixed text,
    left text,
    top text,
    width text,
    height text,
    zindex text,
    widgetname text,
    controlurl text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT P.PlaceNo, P.ModUserNo, P.ModDate, P.WidgetNo, P.BoardNo, P.IsFixed,
		P.Left, P.Top, P.Width, P.Height, P.ZIndex,
		W.Name AS WidgetName, W.ControlUrl
	FROM Main_WidgetPlacements P
	INNER JOIN Main_Widgets W ON W.WidgetNo = P.WidgetNo
	WHERE P.BoardNo = main_getwidgetplacements.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
