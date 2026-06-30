-- ─── FUNCTION: board_updatefolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_updatefolder(integer, integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_updatefolder(
    folderno integer,
    moduserno integer,
    moddate timestamp without time zone,
    name character varying,
    parentno integer,
    sortno integer,
    enabled boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    levelrand character varying;
BEGIN

	IF (PARENTNO >0) BEGIN
		SELECT LevelRand = LevelRand + CONVERT(nvarchar(20), FolderNo) + ','  FROM Board_Folders WHERE FolderNo=board_updatefolder.parentno
	END
	ELSE BEGIN
		SET LevelRand = ','
	END

UPDATE public."Board_Folders"
   SET ModUserNo = board_updatefolder.moduserno
      ,ModDate = board_updatefolder.moddate
      ,Name = board_updatefolder.name
      ,ParentNo = board_updatefolder.parentno
      ,SortNo = board_updatefolder.sortno
      ,Enabled = board_updatefolder.enabled
	  ,LevelRand = LevelRand 
 WHERE FolderNo=board_updatefolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
