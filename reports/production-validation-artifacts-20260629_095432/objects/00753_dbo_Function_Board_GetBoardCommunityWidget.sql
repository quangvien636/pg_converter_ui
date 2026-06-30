-- ─── FUNCTION: board_getboardcommunitywidget ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getboardcommunitywidget(character varying, integer, boolean);
CREATE OR REPLACE FUNCTION public.board_getboardcommunitywidget(
    langcode character varying DEFAULT 'EN',
    userno integer DEFAULT 6656,
    isadmin boolean DEFAULT FALSE
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	WITH DEPARTPERMISSION AS (
	Select ItemNo ,AllowValue,AllowAccessNo 
	FROM Board_DepartAllowAccess BD 
	INNER JOIN Organization_BelongToDepartment OB ON OB.DepartNo=BD.DepartNo
	WHERE BD.ItemType=2 AND OB.UserNo=board_getboardcommunitywidget.userno AND OB.IsDefault= TRUE
)
	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate, 
		COALESCE(CASE WHEN STRPOS(B.Name, '{')>0 THEN COALESCE((SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE B.NAME=board_getboardcommunitywidget.langcode),(SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getboardcommunitywidget.langcode)) ELSE B.Name END,'') AS Name 
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_NewBoardWidget W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	LEFT JOIN Board_AllowAccess BA ON BA.ItemNo=B.BoardNo AND BA.ItemType=2 AND BA.UserNo=board_getboardcommunitywidget.userno
	LEFT JOIN DEPARTPERMISSION D ON D.ItemNo=B.BoardNo
	WHERE W.IsDelete = FALSE AND W.Type=2  AND (IsAdmin = TRUE OR  B.SpecType=1 OR BA.AllowValue IS NOT NULL OR D.AllowValue IS NOT NULL)
	ORDER BY W.Sort DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
