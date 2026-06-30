-- ─── PROCEDURE→FUNCTION: board_gettreesubmenu_v2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_gettreesubmenu_v2(integer, boolean, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.board_gettreesubmenu_v2(
    IN userno integer DEFAULT 222,
    IN isadmin boolean DEFAULT FALSE,
    IN langcode character varying DEFAULT 'EN',
    IN selectedboardno integer DEFAULT 0,
    IN selectedfolderno integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


WITH
 DEPARTPERMISSION AS (
	Select ItemNo, AllowValue, AllowAccessNo, ItemType, ROW_NUMBER() OVER(PARTITION BY ItemNo, UserNo, ItemType ORDER BY ItemNo ASC) AS Rn
	FROM Board_DepartAllowAccess BD
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo = BD.DepartNo
	WHERE OB.UserNo = board_gettreesubmenu_v2.userno AND OB.IsDefault = TRUE
),
History AS (
	SELECT BH.*, ROW_NUMBER() OVER (PARTITION BY BH.UserNo, BH.FolderNo ORDER BY HistoryFolderNo) AS RowNum
	FROM Board_HistoryFolder BH
	WHERE BH.UserNo = board_gettreesubmenu_v2.userno
),
FOLDER AS (
	SELECT BF.*, COALESCE(BH.IsOpen, 1) AS IsOpen
	FROM Board_Folders BF
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = BF.FolderNo AND BA.ItemType = 1 AND BA.UserNo = board_gettreesubmenu_v2.userno
	LEFT JOIN History BH ON BF.FolderNo = BH.FolderNo AND BH.RowNum = 1
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = BF.FolderNo AND D.ItemType = 1
	WHERE BF.Enabled = TRUE AND (IsAdmin = TRUE OR BF.SpecType = 1 OR BA.AllowValue > 0 OR D.AllowValue > 0)
),
BOARD AS (
	SELECT B.BoardNo, B.ModUserNo, B.ModDate, B.Name, B.Description, B.FolderNo, B.DisplayTypeNo, B.SortNo,
			B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount, B.Enabled, B.ViewMode, B.SpecType,
			(SELECT COUNT(*) FROM Board_Contents BC
			WHERE '2020-12-31'::timestamp < BC.RegDate AND (BC.BoardNo = B.BoardNo
				AND BC.Enabled = TRUE
				AND BC.RegUserNo <> board_gettreesubmenu_v2.userno
				AND BC.ContentNo NOT IN (SELECT BV.ContentNo FROM Board_ViewedLogs BV WHERE BV.UserNo = board_gettreesubmenu_v2.userno)
				AND (IsAdmin = TRUE OR BA.AllowValue = 7 OR D.AllowValue = 7 OR
				(  (BC.BoardNo IN (SELECT * FROM public."Board_GetBoardAllow"(UserNo, 2)) OR B.SpecType = 1)
					AND (
						(BC.ContentNo IN (SELECT BS1.ContentNo FROM Board_Sharers BS1 INNER JOIN public."Organization_BelongToDepartment" DP ON DP.DepartNo = BS1.DepartNo AND DP.UserNo = board_gettreesubmenu_v2.userno))
					  OR (BC.ContentNo IN (SELECT BSS1.ContentNo FROM Board_Sharers BSS1 WHERE BSS1.ContentNo = BC.ContentNo AND BSS1.UserNo = board_gettreesubmenu_v2.userno))
					  OR BC.IsShareAll = TRUE
						) )
				))
			) AS CountContent
		FROM Board_Boards B
		LEFT JOIN Board_AllowAccess BA ON BA.ItemNo = B.BoardNo AND BA.ItemType = 2 AND BA.UserNo = board_gettreesubmenu_v2.userno
		LEFT JOIN DEPARTPERMISSION D ON D.ItemNo = B.BoardNo AND D.ItemType = 2 AND Rn = 1
		WHERE B.Enabled = TRUE AND (IsAdmin = TRUE OR B.SpecType = 1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
),
TREESUB AS (
	SELECT COALESCE(CASE WHEN STRPOS(T.Name, '{') > 0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(T.Name) WHERE NAME = board_gettreesubmenu_v2.langcode), (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(T.Name) WHERE NAME = 'KO')) ELSE T.Name END, '') AS Name,
		T.FolderNo AS No, T.ModUserNo, T.ModDate, T.Name AS JsonName, T.ParentNo, T.SortNo, TRUE AS IsFolder, T.IsOpen, 0 AS CountContent, 0 AS ViewMode
	FROM FOLDER T
	UNION ALL
	SELECT COALESCE(CASE WHEN STRPOS(B.Name, '{') > 0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name) WHERE NAME = board_gettreesubmenu_v2.langcode), (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name) WHERE NAME = 'KO')) ELSE B.Name END, '') AS Name,
		B.BoardNo AS No, B.ModUserNo, B.ModDate, B.Name AS JsonName, B.FolderNo AS ParentNo, B.SortNo, FALSE AS IsFolder, FALSE AS IsOpen, B.CountContent, B.ViewMode
	FROM BOARD B
)
RETURN QUERY
SELECT F.*,
	CASE
		WHEN F.IsFolder = TRUE AND F.No = board_gettreesubmenu_v2.selectedfolderno THEN TRUE
		WHEN F.IsFolder = FALSE AND F.No = board_gettreesubmenu_v2.selectedboardno  THEN TRUE
		ELSE FALSE
	END AS IsSelected
FROM TREESUB F
ORDER BY ParentNo ASC, SortNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
