-- ─── FUNCTION: main_updatewidgetplacement ───────────────────────────────
DROP FUNCTION IF EXISTS public.main_updatewidgetplacement(integer, integer, timestamp without time zone, integer, integer, boolean, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_updatewidgetplacement(
    placeno integer,
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
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_WidgetPlacements SET
		ModUserNo = main_updatewidgetplacement.moduserno,
		ModDate = main_updatewidgetplacement.moddate,
		WidgetNo = main_updatewidgetplacement.widgetno,
		BoardNo = main_updatewidgetplacement.boardno,
		IsFixed = main_updatewidgetplacement.isfixed,
		Left = main_updatewidgetplacement.left,
		Top = main_updatewidgetplacement.top,
		Width = main_updatewidgetplacement.width,
		Height = main_updatewidgetplacement.height,
		ZIndex = main_updatewidgetplacement.zindex
	WHERE PlaceNo = main_updatewidgetplacement.placeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
