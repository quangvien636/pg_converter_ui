-- ─── FUNCTION: main_getinitialwidgetplacements ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_getinitialwidgetplacements();
CREATE OR REPLACE FUNCTION public.main_getinitialwidgetplacements(
) RETURNS TABLE(
    placeno text,
    moduserno text,
    moddate text,
    widgetno text,
    isfixed text,
    left text,
    top text,
    width text,
    height text,
    widgetname text,
    controlurl text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT P.PlaceNo, P.ModUserNo, P.ModDate, P.WidgetNo, P.IsFixed, P.Left, P.Top, P.Width, P.Height,
		W.Name AS WidgetName, W.ControlUrl
	FROM Main_InitialWidgetPlacements P
	INNER JOIN Main_Widgets W ON W.WidgetNo = P.WidgetNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
