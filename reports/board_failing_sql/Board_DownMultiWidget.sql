-- ─── PROCEDURE→FUNCTION: board_downmultiwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_downmultiwidget(integer, integer);
CREATE OR REPLACE FUNCTION public.board_downmultiwidget(
    IN userno integer,
    IN boardno integer
) RETURNS void
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT Sort INTO sorttemp FROM Board_MultiBoardWidget WHERE  BoardNo = board_downmultiwidget.boardno  AND IsDelete= FALSE
	CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No,Sort FROM Board_MultiBoardWidget
	WHERE IsDelete= FALSE AND Sort<=SortTemp
	ORDER BY Sort DESC;
	UPDATE BW SET BW.Sort=(SELECT /* /* TOP 1 */ */T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),BW.ModUserNo= board_downmultiwidget.userno,BW.ModDate=NOW()
	FROM Board_MultiBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.