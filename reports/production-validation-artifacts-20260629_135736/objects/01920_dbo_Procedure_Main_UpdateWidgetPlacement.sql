-- ─── PROCEDURE→FUNCTION: main_updatewidgetplacement ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_updatewidgetplacement(integer, integer, timestamp without time zone, integer, integer, boolean, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_updatewidgetplacement(
    IN placeno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN widgetno integer,
    IN boardno integer,
    IN isfixed boolean,
    IN left integer,
    IN top integer,
    IN width integer,
    IN height integer,
    IN zindex integer
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
