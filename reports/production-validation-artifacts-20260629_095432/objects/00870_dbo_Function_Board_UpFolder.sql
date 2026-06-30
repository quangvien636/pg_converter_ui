-- ─── FUNCTION: board_upfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_upfolder(integer);
CREATE OR REPLACE FUNCTION public.board_upfolder(
    folderno integer
) RETURNS void
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    foldertempno integer;
    ranktempno integer;
BEGIN




select PARENTNO=ParentNo,SORTNO=SortNo from Board_Folders where FolderNo= board_upfolder.folderno
SET RANKTEMPNO=1

SELECT FolderNo from Board_Folders WHERE PARENTNO=ParentNo AND Enabled = TRUE ORDER BY SortNo ASC, FolderNo ASC
OPEN Board_Cursor;
FETCH NEXT FROM Board_Cursor 
INTO FOLDERTEMPNO
WHILE @FETCH_STATUS = 0
   BEGIN	;
		UPDATE Board_Folders SET SortNo = RANKTEMPNO WHERE FOLDERTEMPNO=board_upfolder.folderno
		
		IF (FOLDERTEMPNO=board_upfolder.folderno)
		BEGIN
			SET SORTNO=RANKTEMPNO
		END

		SET RANKTEMPNO = RANKTEMPNO + 1
		FETCH NEXT FROM Board_Cursor
		INTO FOLDERTEMPNO
   END;
CLOSE Board_Cursor;
DEALLOCATE Board_Cursor;

UPDATE Board_Folders SET SortNo = SORTNO WHERE SORTNO = SortNo + 1 AND ParentNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Folders SET SortNo = SORTNO-1 WHERE FolderNo = board_upfolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
