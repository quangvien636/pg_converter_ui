-- ─── PROCEDURE→FUNCTION: board_downwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_downwidget(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.board_downwidget(
    IN userno integer,
    IN boardno integer,
    IN type integer
) RETURNS void
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	CREATE TEMP TABLE WidgetTemp AS SELECT Sort INTO sorttemp FROM Board_NewBoardWidget WHERE  BoardNo = board_downwidget.boardno AND Type=board_downwidget.type AND IsDelete= FALSE
	SELECT /* /* TOP 2 */ */ No,Sort FROM Board_NewBoardWidget
	WHERE Type=board_downwidget.type AND IsDelete= FALSE AND Sort<=SortTemp
	ORDER BY Sort DESC;
	UPDATE BW SET BW.Sort=(SELECT /* /* TOP 1 */ */T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),BW.ModUserNo= board_downwidget.userno,BW.ModDate=NOW()
	FROM Board_NewBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
