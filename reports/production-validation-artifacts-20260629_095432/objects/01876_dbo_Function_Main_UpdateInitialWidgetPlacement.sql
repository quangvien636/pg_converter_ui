-- ─── FUNCTION: main_updateinitialwidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_updateinitialwidgetplacement(integer, integer, timestamp without time zone, integer, boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.main_updateinitialwidgetplacement(
    placeno integer,
    moduserno integer,
    moddate timestamp without time zone,
    widgetno integer,
    isfixed boolean,
    left integer,
    top integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_InitialWidgetPlacements SET
		ModUserNo = main_updateinitialwidgetplacement.moduserno,
		ModDate = main_updateinitialwidgetplacement.moddate,
		WidgetNo = main_updateinitialwidgetplacement.widgetno,
		IsFixed = main_updateinitialwidgetplacement.isfixed,
		Left = main_updateinitialwidgetplacement.left,
		Top = main_updateinitialwidgetplacement.top
	WHERE PlaceNo = main_updateinitialwidgetplacement.placeno
	
	DELETE FROM Main_WidgetPlacements WHERE WidgetNo = main_updateinitialwidgetplacement.widgetno
	
	INSERT INTO Main_WidgetPlacements (ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top)
	SELECT ModUserNo, ModDate, WidgetNo, BoardNo, IsFixed, Left, Top
	FROM Main_DashBoards;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
