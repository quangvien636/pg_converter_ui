-- ─── PROCEDURE→FUNCTION: board_treeboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_treeboard();
CREATE OR REPLACE FUNCTION public.board_treeboard(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


WITH FOLDER AS
(
    SELECT     FolderNo as No ,Name,ParentNo, 0 as IsBoard,FolderNo as RootTree,1 as Index
    FROM       Board_Folders
    WHERE      ParentNo = 0 AND Enabled = TRUE
    UNION ALL
    SELECT     C.FolderNo as No,C.Name,C.ParentNo, 0 as IsBoard,F.RootTree,(F.Index + 1) AS Index
    FROM       Board_Folders C
    INNER JOIN FOLDER F ON F.No = C.ParentNo AND C.Enabled = TRUE AND F.IsBoard = FALSE
	UNION ALL
	SELECT B.BoardNo as No ,B.Name,B.FolderNo as ParentNo,1 as IsBoard ,F.RootTree,(F.Index + 1) AS Index
	FROM Board_Boards B
	INNER JOIN FOLDER F on F.No= B.FolderNo AND B.Enabled = TRUE AND F.IsBoard = FALSE 
), TEMP AS (
	SELECT RootTree, MAX(Index) AS LastRoot 
	FROM FOLDER
	GROUP BY RootTree
)
RETURN QUERY
SELECT F.* , (CASE WHEN T.LastRoot IS NULL THEN 0 ELSE 1 END) AS  LastRoot 
	FROM FOLDER F
	LEFT JOIN TEMP T ON T.RootTree=F.RootTree And T.LastRoot=F.Index
	ORDER BY RootTree,ParentNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
