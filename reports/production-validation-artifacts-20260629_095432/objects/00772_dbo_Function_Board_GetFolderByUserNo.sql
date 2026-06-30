-- ─── FUNCTION: board_getfolderbyuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getfolderbyuserno(integer, boolean, boolean);
CREATE OR REPLACE FUNCTION public.board_getfolderbyuserno(
    userno integer DEFAULT 70,
    isdisabled boolean DEFAULT FALSE,
    isadmin boolean DEFAULT TRUE
) RETURNS TABLE(
    col1 text,
    isopen text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

 
WITH DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=1 AND OB.UserNo=board_getfolderbyuserno.userno AND OB.IsDefault= TRUE
),
PARENTS AS (
	SELECT /* TOP 1000 */ BF.* 
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_getfolderbyuserno.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo
	WHERE  BF.ParentNo = 0 AND  BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 OR D.AllowValue>0)
	ORDER BY SortNo ASC,FolderNo ASC),
CHILDRENTS AS (
	SELECT /* TOP 1000 */ BF.* 
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_getfolderbyuserno.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo
	WHERE  BF.ParentNo >0 AND  BF.Enabled = TRUE  AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue>0 OR D.AllowValue>0)
	ORDER BY SortNo ASC,FolderNo ASC),
FOLDER AS
(
    SELECT     T.FolderNo  ,T.ModUserNo,T.ModDate, T.Name, T.ParentNo, T.SortNo, T.Enabled, T.LevelRand,T.SpecType
    FROM       PARENTS T
    UNION ALL
    SELECT     C.FolderNo, C.ModUserNo, C.ModDate, C.Name, C.ParentNo, C.SortNo, C.Enabled, C.LevelRand,C.SpecType
    FROM       CHILDRENTS C
    INNER JOIN FOLDER F ON F.FolderNo = C.ParentNo AND C.Enabled=~IsDisabled 
),
History AS (
	SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY  BH.UserNo,BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum 
	FROM Board_HistoryFolder BH WHERE BH.UserNo=board_getfolderbyuserno.userno
)
RETURN QUERY
SELECT F.* ,COALESCE(BH.IsOpen,1) AS IsOpen
FROM FOLDER F
LEFT JOIN History BH ON  F.FolderNo=BH.FolderNo AND BH.RowNum=1
ORDER BY F.ParentNo ASC, F.SortNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
