-- ─── PROCEDURE→FUNCTION: board_upfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_upfolder(integer);
CREATE OR REPLACE FUNCTION public.board_upfolder(
    IN folderno integer
) RETURNS void
AS $function$
DECLARE
    parentno integer;
    sortno integer;
    foldertempno integer;
    ranktempno integer;
BEGIN




SELECT ParentNo, SortNo INTO parentno, sortno from Board_Folders where FolderNo= board_upfolder.folderno
RANKTEMPNO := 1;
FOR _rec IN SELECT FolderNo from Board_Folders WHERE PARENTNO=ParentNo AND Enabled = TRUE ORDER BY SortNo ASC, FolderNo ASC
LOOP
    foldertempno
WHILE := _rec.folderno LOOP

		UPDATE Board_Folders SET SortNo = RANKTEMPNO WHERE FOLDERTEMPNO=board_upfolder.folderno
		
		IF FOLDERTEMPNO=board_upfolder.folderno THEN
			SORTNO := RANKTEMPNO;
		END IF;

		RANKTEMPNO := RANKTEMPNO + 1;
		   END LOOP;;
UPDATE Board_Folders SET SortNo = SORTNO WHERE SORTNO = SortNo + 1 AND ParentNo=PARENTNO AND Enabled = TRUE;
UPDATE Board_Folders SET SortNo = SORTNO-1 WHERE FolderNo = board_upfolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
