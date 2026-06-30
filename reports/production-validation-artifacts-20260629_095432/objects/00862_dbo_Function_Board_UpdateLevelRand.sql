-- ─── FUNCTION: board_updatelevelrand ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updatelevelrand(integer);
CREATE OR REPLACE FUNCTION public.board_updatelevelrand(
    parentid integer
) RETURNS void
AS $function$
DECLARE
    folderno integer;
    levelrand character varying;
    board_cursor cursor;
BEGIN


	IF (ParentId = 0)
	BEGIN;
		UPDATE Board_Folders SET LevelRand =  ',' WHERE ParentNo= board_updatelevelrand.parentid
	END
	ELSE 
	BEGIN;
		UPDATE Board_Folders SET LevelRand = ParentRand  + CAST(ParentId AS nvarchar(500)) + ',' WHERE ParentNo= board_updatelevelrand.parentid
	END





	SET Board_Cursor = CURSOR FAST_FORWARD
	FOR
		SELECT FolderNo,LevelRand FROM Board_Folders WHERE ParentNo= board_updatelevelrand.parentid
	OPEN Board_Cursor

	FETCH NEXT FROM Board_Cursor

	INTO FolderNo, LevelRand
	WHILE @FETCH_STATUS = 0
	BEGIN
		

		EXEC Board_UpdateLevelRand FolderNo, LevelRand

		FETCH NEXT FROM Board_Cursor
		INTO FolderNo, LevelRand
	END
	CLOSE Board_Cursor
	DEALLOCATE Board_Cursor;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
