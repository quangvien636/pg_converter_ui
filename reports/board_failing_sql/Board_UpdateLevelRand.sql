-- ─── PROCEDURE→FUNCTION: board_updatelevelrand ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.board_updatelevelrand(integer);
CREATE OR REPLACE FUNCTION public.board_updatelevelrand(
    IN parentid integer
) RETURNS void
AS $function$
DECLARE
    folderno integer;
    levelrand character varying;
BEGIN


	IF ParentId = 0 THEN
		UPDATE Board_Folders SET LevelRand =  ',' WHERE ParentNo= board_updatelevelrand.parentid;
	ELSE
		UPDATE Board_Folders SET LevelRand = ParentRand  + CAST(ParentId AS nvarchar(500)) + ',' WHERE ParentNo= board_updatelevelrand.parentid;
	END IF;






	FETCH NEXT FROM Board_Cursor

	INTO FolderNo, LevelRand
	FOR folderno, levelrand IN SELECT FolderNo,LevelRand FROM Board_Folders WHERE ParentNo= board_updatelevelrand.parentid LOOP


		PERFORM board_updatelevelrand(FolderNo, LevelRand

			END);
END LOOP;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.