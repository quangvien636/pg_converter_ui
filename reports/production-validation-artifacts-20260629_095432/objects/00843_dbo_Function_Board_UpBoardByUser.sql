-- ─── FUNCTION: board_upboardbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_upboardbyuser(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_upboardbyuser(
    boardno integer,
    userno integer DEFAULT 70,
    isadmin boolean DEFAULT TRUE
) RETURNS TABLE(
    col1 text,
    col2 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

SELECT CurentNo = SortNo,ParentNo=FolderNo FROM Board_Boards WHERE  BoardNo = board_upboardbyuser.boardno 

RETURN QUERY
SELECT /* /* TOP 1 */ */ DownNo = T.SortNo,IsBoard=T.IsBoard   FROM(
	SELECT /* /* TOP 1 */ */ BoardNo AS No, SortNo,TRUE AS IsBoard FROM Board_Boards B
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_upboardbyuser.userno
	WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo>CurentNo AND ParentNo=B.FolderNo
	ORDER BY SortNo ASC
	UNION ALL 
	SELECT /* /* TOP 1 */ */ BF.FolderNo AS No, SortNo,FALSE AS IsBoard
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_upboardbyuser.userno
	WHERE  BF.SortNo>CurentNo AND ParentNo=BF.ParentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
	ORDER BY SortNo ASC) T ORDER BY T.SortNo ASC

--SELECT DownNo = SortNo,IsBoard=IsBoard FROM TEMPUPDATE
IF DownNo >0 AND IsBoard= TRUE;
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Boards SET SortNo=DownNo WHERE BoardNo = board_upboardbyuser.boardno ;
IF DownNo >0 AND IsBoard= FALSE;
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Boards SET SortNo=DownNo WHERE BoardNo = board_upboardbyuser.boardno ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
