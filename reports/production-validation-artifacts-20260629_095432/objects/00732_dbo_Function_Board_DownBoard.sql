-- ─── FUNCTION: board_downboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_downboard(integer);
CREATE OR REPLACE FUNCTION public.board_downboard(
    boardno integer
) RETURNS void
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    tempno integer;
    ranktempno integer;
BEGIN




select PARENTNO=FolderNo,SORTNO=SortNo from Board_Boards where BoardNo= board_downboard.boardno
SET RANKTEMPNO=1

SELECT  BoardNo from Board_Boards WHERE PARENTNO=FolderNo AND Enabled = TRUE ORDER BY SortNo ASC,BoardNo ASC
OPEN Board_Cursor
FETCH NEXT FROM Board_Cursor 
INTO TEMPNO
WHILE @FETCH_STATUS = 0
   BEGIN	;
		UPDATE Board_Boards SET SortNo = RANKTEMPNO WHERE TEMPNO=board_downboard.boardno
		
		IF (TEMPNO=board_downboard.boardno)
		BEGIN
			SET SORTNO=RANKTEMPNO
		END
		SET RANKTEMPNO=RANKTEMPNO+1
		FETCH NEXT FROM Board_Cursor
		INTO  TEMPNO
   END;
CLOSE Board_Cursor;
DEALLOCATE Board_Cursor;

UPDATE Board_Boards SET SortNo = SORTNO WHERE SORTNO = SortNo - 1 AND FolderNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Boards SET SortNo = SORTNO + 1 WHERE BoardNo= board_downboard.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
