-- ─── FUNCTION: board_downmultilwidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_downmultilwidget(integer, integer);
CREATE OR REPLACE FUNCTION public.board_downmultilwidget(
    userno integer,
    boardno integer
) RETURNS void
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    sorttemp integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	SELECT SortTemp = Sort FROM Board_MultiBoardWidget WHERE  BoardNo = board_downmultilwidget.boardno  AND IsDelete= FALSE
	SELECT /* /* TOP 2 */ */ No,Sort
    INTO #WidgetTemp
    FROM Board_MultiBoardWidget
	WHERE IsDelete= FALSE AND Sort<=SortTemp
	ORDER BY Sort DESC;
	UPDATE BW SET BW.Sort=(SELECT /* /* TOP 1 */ */T.Sort FROM #WidgetTemp T WHERE BW.No <>T.No),BW.ModUserNo= board_downmultilwidget.userno,BW.ModDate=NOW()
	FROM Board_MultiBoardWidget BW
	INNER JOIN #WidgetTemp T ON T.No=BW.No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
