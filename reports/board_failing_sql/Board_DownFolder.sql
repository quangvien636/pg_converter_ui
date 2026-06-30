-- ─── PROCEDURE→FUNCTION: board_downfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_downfolder(integer);
CREATE OR REPLACE FUNCTION public.board_downfolder(
    IN folderno integer
) RETURNS void
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    foldertempno integer;
    ranktempno integer;
BEGIN




SELECT ParentNo, SortNo INTO parentno, sortno FROM Board_Folders where FolderNo= board_downfolder.folderno;
RANKTEMPNO := 1;
SELECT FolderNo from Board_Folders WHERE PARENTNO=ParentNo AND Enabled = TRUE ORDER BY SortNo ASC, FolderNo ASC
OPEN Board_Cursor;
FETCH NEXT FROM Board_Cursor 
INTO FOLDERTEMPNO;
WHILE @FETCH_STATUS = 0
   BEGIN	
		UPDATE Board_Folders SET SortNo = RANKTEMPNO WHERE FOLDERTEMPNO=board_downfolder.folderno;
		
		IF FOLDERTEMPNO=board_downfolder.folderno THEN
			SORTNO := RANKTEMPNO;
		END IF;

		RANKTEMPNO := RANKTEMPNO + 1;
		FETCH NEXT FROM Board_Cursor
		INTO FOLDERTEMPNO
   END;
CLOSE Board_Cursor;
DEALLOCATE Board_Cursor;

UPDATE Board_Folders SET SortNo = SORTNO WHERE SORTNO = SortNo - 1 AND ParentNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Folders SET SortNo = SORTNO+1 WHERE FolderNo = board_downfolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.