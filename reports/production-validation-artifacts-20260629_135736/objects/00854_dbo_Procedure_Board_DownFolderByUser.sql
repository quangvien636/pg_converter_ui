-- ─── PROCEDURE→FUNCTION: board_downfolderbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_downfolderbyuser(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_downfolderbyuser(
    IN folderno integer,
    IN userno integer DEFAULT 70,
    IN isadmin boolean DEFAULT TRUE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

SELECT SortNo, ParentNo INTO curentno, parentno FROM Board_Folders WHERE  FolderNo = board_downfolderbyuser.folderno 

RETURN QUERY
SELECT /* /* TOP 1 */ */ UpNo = T.SortNo,IsFolder=T.IsFolder   FROM(
	SELECT /* /* TOP 1 */ */ BoardNo AS No, SortNo,FALSE AS IsFolder FROM Board_Boards B
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_downfolderbyuser.userno
	WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo<CurentNo AND ParentNo=B.FolderNo
	ORDER BY SortNo DESC
	UNION ALL 
	SELECT /* /* TOP 1 */ */ BF.FolderNo AS No, SortNo,TRUE AS IsFolder
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_downfolderbyuser.userno
	WHERE  BF.SortNo<CurentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
	ORDER BY SortNo DESC) T ORDER BY T.SortNo DESC

--SELECT SortNo, IsBoard INTO downno, isboard FROM TEMPUPDATE
IF UpNo >0 AND IsFolder= TRUE THEN;
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=UpNo;
	UPDATE Board_Folders SET SortNo=UpNo WHERE FolderNo = board_downfolderbyuser.folderno ;
IF UpNo >0 AND IsFolder= FALSE THEN;
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=UpNo;
	UPDATE Board_Folders SET SortNo=UpNo WHERE FolderNo = board_downfolderbyuser.folderno ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
