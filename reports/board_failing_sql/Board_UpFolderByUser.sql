-- ─── PROCEDURE→FUNCTION: board_upfolderbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_upfolderbyuser(integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_upfolderbyuser(
    IN folderno integer DEFAULT 116,
    IN userno integer DEFAULT 70,
    IN isadmin boolean DEFAULT TRUE
) RETURNS SETOF record
AS $function$
DECLARE
    curentno integer;
    parentno integer;
    downno integer;
    isfolder boolean;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

SELECT SortNo, ParentNo INTO curentno, parentno FROM Board_Folders WHERE  FolderNo = board_upfolderbyuser.folderno;

SELECT T.SortNo, T.IsFolder INTO downno, isfolder FROM (
SELECT BoardNo AS No, SortNo,FALSE AS IsFolder FROM Board_Boards B
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_upfolderbyuser.userno
WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL) AND B.SortNo>CurentNo AND ParentNo=B.FolderNo
UNION ALL;
SELECT BF.FolderNo AS No, SortNo,TRUE AS IsFolder
FROM  Board_Folders BF
LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_upfolderbyuser.userno
WHERE  BF.SortNo>CurentNo AND ParentNo=BF.ParentNo AND BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 )
ORDER BY SortNo ASC) T ORDER BY T.SortNo ASC;











--SELECT SortNo, IsBoard INTO downno, isboard FROM TEMPUPDATE
IF DownNo >0 AND IsFolder= TRUE THEN
	UPDATE Board_Folders SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Folders SET SortNo=DownNo WHERE FolderNo = board_upfolderbyuser.folderno ;
IF DownNo >0 AND IsFolder= FALSE THEN
	UPDATE Board_Boards SET SortNo=CurentNo WHERE SortNo=DownNo;
	UPDATE Board_Folders SET SortNo=DownNo WHERE FolderNo = board_upfolderbyuser.folderno ;

END IF;
END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.