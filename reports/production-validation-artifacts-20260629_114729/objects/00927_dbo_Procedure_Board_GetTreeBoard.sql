-- ─── PROCEDURE→FUNCTION: board_gettreeboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_gettreeboard(boolean, character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_gettreeboard(
    IN isdisabled boolean DEFAULT TRUE,
    IN langcode character varying DEFAULT 'EN',
    IN userno integer DEFAULT 70,
    IN isadmin boolean DEFAULT TRUE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


WITH 
 DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo ,ItemType
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE  OB.UserNo=board_gettreeboard.userno AND OB.IsDefault= TRUE
),
PARENTS AS (
	SELECT /* TOP 1000 */ BF.* 
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_gettreeboard.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE  BF.ParentNo = 0 AND  BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType=1  OR BA.AllowValue IS NOT NULL  OR D.AllowValue IS NOT NULL)
	ORDER BY SortNo ASC,FolderNo ASC),
CHILDRENTS AS (
	SELECT /* TOP 1000 */ BF.* 
	FROM  Board_Folders BF  
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=BF.FolderNo AND BA.ItemType=1 AND BA.UserNo=board_gettreeboard.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=BF.FolderNo AND D.ItemType=1
	WHERE  BF.ParentNo >0 AND  BF.Enabled = TRUE  AND (IsAdmin = TRUE OR BF.SpecType=1 OR BA.AllowValue IS NOT NULL  OR D.AllowValue IS NOT NULL)
	ORDER BY SortNo ASC,FolderNo ASC),
BOARDCHILD AS (
	SELECT B.* 
	FROM Board_Boards B
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_gettreeboard.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo AND D.ItemType=2
	WHERE  B.Enabled = TRUE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL  OR D.AllowValue IS NOT NULL)
),
FOLDER AS
(
    SELECT     T.FolderNo as No ,T.Name,T.ParentNo, FALSE as IsBoard,T.SortNo as RootTree,1 as Index,T.SortNo,0 AS ViewMode
    FROM       PARENTS T
    UNION ALL
    SELECT     C.FolderNo as No,C.Name,C.ParentNo, FALSE as IsBoard,F.RootTree,(F.Index + 1) AS Index,C.SortNo,0 AS ViewMode
    FROM       CHILDRENTS C
    INNER JOIN FOLDER F ON F.No = C.ParentNo AND C.Enabled=board_gettreeboard.isdisabled AND F.IsBoard = FALSE
	UNION ALL
	SELECT B.BoardNo as No ,B.Name,B.FolderNo as ParentNo,TRUE as IsBoard ,F.RootTree,(F.Index + 1) AS Index,B.SortNo,B.ViewMode AS ViewMode
	FROM BOARDCHILD B
	INNER JOIN FOLDER F on F.No= B.FolderNo AND B.Enabled=board_gettreeboard.isdisabled AND F.IsBoard = FALSE 
), TEMP AS (
	SELECT RootTree, MAX(Index) AS LastRoot 
	FROM FOLDER
	GROUP BY RootTree
)
RETURN QUERY
SELECT	F.No ,
		--F.Name ,
		COALESCE(CASE WHEN STRPOS(F.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(F.Name)  WHERE F.NAME=board_gettreeboard.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(F.Name)  WHERE NAME='KO')) ELSE F.Name END,'') AS Name ,
		F.ParentNo ,
		F.IsBoard ,
		F.RootTree ,
		F.Index ,
		Cast((CASE WHEN T.LastRoot IS NULL THEN 0 ELSE 1 END) AS BIT) AS IsLastRoot ,
		F.ViewMode
	FROM FOLDER F
	LEFT JOIN TEMP T ON T.RootTree=F.RootTree And T.LastRoot=F.Index
	ORDER BY  ParentNo ASC,--IsBoard DESC,
	F.SortNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
