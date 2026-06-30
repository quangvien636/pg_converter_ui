-- ─── PROCEDURE→FUNCTION: board_downboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_downboard(integer);
CREATE OR REPLACE FUNCTION public.board_downboard(
    IN boardno integer
) RETURNS void
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN




SELECT FolderNo, SortNo INTO parentno, sortno from Board_Boards where BoardNo= board_downboard.boardno
RANKTEMPNO := 1;
FOR _rec IN SELECT  BoardNo from Board_Boards WHERE PARENTNO=FolderNo AND Enabled = TRUE ORDER BY SortNo ASC,BoardNo ASC
LOOP
    tempno
WHILE := _rec.boardno LOOP

		UPDATE Board_Boards SET SortNo = RANKTEMPNO WHERE TEMPNO=board_downboard.boardno
		
		IF TEMPNO=board_downboard.boardno THEN
			SORTNO := RANKTEMPNO;
		END IF;
		RANKTEMPNO := RANKTEMPNO+1;
		   END LOOP;;
UPDATE Board_Boards SET SortNo = SORTNO WHERE SORTNO = SortNo - 1 AND FolderNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Boards SET SortNo = SORTNO + 1 WHERE BoardNo= board_downboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
