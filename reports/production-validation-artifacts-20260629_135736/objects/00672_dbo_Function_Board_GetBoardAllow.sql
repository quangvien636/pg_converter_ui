-- ─── FUNCTION: board_getboardallow ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getboardallow(integer, integer);
CREATE OR REPLACE FUNCTION public.board_getboardallow(
    userno integer,
    role integer
) RETURNS TABLE(
    boardno integer
)
AS $function$
#variable_conflict use_column
BEGIN

 INSERT INTO ReturnBoardAllow
	RETURN QUERY
	SELECT B.BoardNo FROM Board_Boards B LEFT JOIN Board_Folders F ON B.FolderNo = F.FolderNo 
	WHERE B.BoardNo In (SELECT A.ItemNo FROM Board_AllowAccess A WHERE A.UserNo=board_getboardallow.userno AND A.ItemType=2 AND (A.AllowValue & Role) > 0 )
	 OR (SELECT COUNT(*) FROM Board_AllowAccess V WHERE  V.UserNo=board_getboardallow.userno AND V.ItemType=1 AND (V.AllowValue & Role) > 0 AND (F.LevelRand + CAST(F.FolderNo AS nvarchar(500)) + ',') ILIKE ('%,' || CAST(V.ItemNo AS nvarchar(500))  + ',%' )) > 0
	--SELECT * FROM ReturnWorkingTime ORDER BY CheckTime

	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
