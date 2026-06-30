-- ─── PROCEDURE→FUNCTION: board_getallboardwidget ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_getallboardwidget(character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getallboardwidget(
    IN langcode character varying DEFAULT 'EN',
    IN userno integer DEFAULT 6656,
    IN isadmin boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	WITH DEPARTPERMISSION AS (
		Select ItemNo ,AllowValue,AllowAccessNo 
		FROM Board_DepartAllowAccess BD 
		INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
		WHERE BD.ItemType=2 AND OB.UserNo=board_getallboardwidget.userno AND OB.IsDefault= TRUE
)
	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate, 
		COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE B.NAME=board_getallboardwidget.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME='KO')) ELSE B.Name END,'') AS Name 
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_NewBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.UserNo=board_getallboardwidget.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE W.IsDelete = FALSE  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
	ORDER BY W.Sort DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
