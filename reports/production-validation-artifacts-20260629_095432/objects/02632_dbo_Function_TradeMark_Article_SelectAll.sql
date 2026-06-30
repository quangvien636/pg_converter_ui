-- ─── FUNCTION: trademark_article_selectall ───────────────────────────────
DROP FUNCTION IF EXISTS public.trademark_article_selectall();
CREATE OR REPLACE FUNCTION public.trademark_article_selectall(
) RETURNS TABLE(
    articleid text,
    title text,
    description text,
    articlekind text,
    status text,
    proid text,
    regno text,
    regdate text,
    modno text,
    moddate text
)
AS $function$
BEGIN
RETURN QUERY
SELECT
		ArticleId,
		Title,
		Description,
		ArticleKind,
		Status,
		ProId,
		RegNo,
		RegDate,
		ModNo,
		ModDate
		
FROM
		public."TradeMark_Article";
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
