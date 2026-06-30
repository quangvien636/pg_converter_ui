-- ─── FUNCTION: board_setfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_setfolders(integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_setfolders(
    mod_user_id integer,
    date timestamp without time zone,
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
  SELECT LevelRand = LevelRand + CONVERT(nvarchar(20), FolderNo) + ','  FROM Board_Folders WHERE FolderNo=board_setfolders.parentno
 END
 ELSE BEGIN
  SET LevelRand = ','
 END;
 INSERT INTO Board_Folders(ModUserNo, ModDate, Name, ParentNo, SortNo,Enabled,LevelRand) VALUES (MOD_USER_ID, DATE, NAME, PARENTNO, SORTNO, ENABLED,LevelRand);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
