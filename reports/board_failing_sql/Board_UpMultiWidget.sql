-- ─── PROCEDURE→FUNCTION: board_upmultiwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_upmultiwidget(integer, integer);
CREATE OR REPLACE FUNCTION public.board_upmultiwidget(
    IN userno integer,
    IN boardno integer
) RETURNS void
AS $function$
DECLARE
    sorttemp integer;
BEGIN


	SELECT Sort INTO sorttemp FROM Board_MultiBoardWidget WHERE  BoardNo = board_upmultiwidget.boardno AND  IsDelete= FALSE;
	CREATE TEMP TABLE WidgetTemp ON COMMIT DROP AS SELECT No,Sort FROM Board_MultiBoardWidget
	WHERE  IsDelete= FALSE AND Sort>=SortTemp
	ORDER BY Sort ASC;
	UPDATE BW SET BW.Sort=(SELECT TOP(1)T.Sort FROM WidgetTemp T WHERE BW.No <>T.No),BW.ModUserNo= board_upmultiwidget.userno,BW.ModDate=NOW()
	FROM Board_MultiBoardWidget BW
	INNER JOIN WidgetTemp T ON T.No=BW.No;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.