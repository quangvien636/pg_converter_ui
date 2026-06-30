-- ─── PROCEDURE→FUNCTION: main_updateuserwidgetplacement_position ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.main_updateuserwidgetplacement_position(integer, integer, timestamp without time zone, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.main_updateuserwidgetplacement_position(
    IN placeno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN left integer,
    IN top integer,
    IN width integer,
    IN height integer,
    IN zindex integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Main_UserWidgetPlacements SET
		ModUserNo = main_updateuserwidgetplacement_position.moduserno,
		ModDate = main_updateuserwidgetplacement_position.moddate,
		Left = main_updateuserwidgetplacement_position.left,
		Top = main_updateuserwidgetplacement_position.top,
		Width = main_updateuserwidgetplacement_position.width,
		Height = main_updateuserwidgetplacement_position.height,
		ZIndex = main_updateuserwidgetplacement_position.zindex
	WHERE PlaceNo = main_updateuserwidgetplacement_position.placeno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
