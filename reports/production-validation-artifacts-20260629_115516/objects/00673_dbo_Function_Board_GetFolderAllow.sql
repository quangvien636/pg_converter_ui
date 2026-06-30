-- ─── FUNCTION: board_getfolderallow ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getfolderallow(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getfolderallow(
    userno integer,
    role integer
) RETURNS TABLE(
    folderno integer
)
AS $function$
#variable_conflict use_column
BEGIN

 INSERT INTO ReturnFolderAllow
	RETURN QUERY
	SELECT B.FolderNo FROM Board_Folders B  
	WHERE(SELECT COUNT(*) FROM Board_AllowAccess V WHERE  V.UserNo=board_getfolderallow.userno AND V.ItemType=1 AND (V.AllowValue & Role) > 0 AND (B.LevelRand + CAST(B.FolderNo AS nvarchar(500)) + ',') ILIKE ('%,' || CAST(V.ItemNo AS nvarchar(500))  + ',%' )) > 0
	--SELECT * FROM ReturnWorkingTime ORDER BY CheckTime

	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
