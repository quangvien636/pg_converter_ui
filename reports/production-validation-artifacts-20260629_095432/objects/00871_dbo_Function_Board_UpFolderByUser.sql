-- ─── FUNCTION: board_upfolderbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_upfolderbyuser(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_upfolderbyuser(
    folderno integer DEFAULT 116,
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

SELECT CurentNo = SortNo,ParentNo=ParentNo FROM Board_Folders WHERE  FolderNo = board_upfolderbyuser.folderno 

RETURN QUERY
SELECT /* /* TOP 1 */ */ DownNo = T.SortNo,IsFolder=T.IsFolder   FROM(
	SELECT /* /* TOP 1 */ */ BoardNo AS No, SortNo,FALSE AS IsFolder FROM Board_Boards B
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_upfolderbyuser.userno
	WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo>CurentNo AND ParentNo=B.FolderNo
	ORDER BY SortNo ASC
	UNION ALL 
	SELECT /* /* TOP 1 */ */ BF.FolderNo AS No, SortNo,TRUE AS IsFolder
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_upfolderbyuser.userno
	WHERE  BF.SortNo>CurentNo AND ParentNo=BF.ParentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
	ORDER BY SortNo ASC) T ORDER BY T.SortNo ASC

--SELECT DownNo = SortNo,IsBoard=IsBoard FROM TEMPUPDATE
IF DownNo >0 AND IsFolder= TRUE;
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Folders SET SortNo=DownNo WHERE FolderNo = board_upfolderbyuser.folderno ;
IF DownNo >0 AND IsFolder= FALSE;
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Folders SET SortNo=DownNo WHERE FolderNo = board_upfolderbyuser.folderno ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
