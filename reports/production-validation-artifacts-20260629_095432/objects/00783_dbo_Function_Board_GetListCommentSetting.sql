-- ─── FUNCTION: board_getlistcommentsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getlistcommentsetting(character varying);
CREATE OR REPLACE FUNCTION public.board_getlistcommentsetting(
    langcode character varying DEFAULT 'EN'
) RETURNS TABLE(
    boardno text,
    moduserno text,
    moddate text,
    col4 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT B.BoardNo,B.ModUserNo, B.ModDate, 
		CASE WHEN STRPOS(B.Name, '{')>0 THEN (SELECT /* /* TOP 1 */ */ StringValue FROM ParseJson(B.Name)  WHERE NAME=board_getlistcommentsetting.langcode) ELSE B.Name END AS Name 
		, B.Description, B.FolderNo, B.DisplayTypeNo,
		B.SortNo, B.IsReply, B.IsHead, B.IsNotice, B.IsRecommend, B.RecommendedDisplayCount,B.ViewMode, B.Enabled,B.SpecType
	FROM Board_CommentSetting W
	INNER JOIN Board_Boards B ON W.BoardNo=B.BoardNo
	WHERE W.IsDelete = FALSE
	ORDER BY RegDate DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
