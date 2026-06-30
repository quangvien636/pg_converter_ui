-- ─── FUNCTION: main_getwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getwidgetplacement(integer);
CREATE OR REPLACE FUNCTION public.main_getwidgetplacement(
    widgetno integer
) RETURNS TABLE(
    placeno text,
    moduserno text,
    moddate text,
    widgetno text,
    boardno text,
    left text,
    top text,
    widgetname text,
    widgetwidth text,
    widgetheight text,
    controlurl text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT P.PlaceNo, P.ModUserNo, P.ModDate, P.WidgetNo, P.BoardNo, P.Left, P.Top,
		W.Name AS WidgetName, W.Width AS WidgetWidth, W.Height AS WidgetHeight, W.ControlUrl
	FROM Main_WidgetPlacements P
	INNER JOIN Main_Widgets W ON W.WidgetNo = P.WidgetNo
	WHERE P.WidgetNo = main_getwidgetplacement.widgetno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
