-- ─── FUNCTION: trademark_article_delete ───────────────────────────────
DROP FUNCTION IF EXISTS public.trademark_article_delete();
CREATE OR REPLACE FUNCTION public.trademark_article_delete(
) RETURNS void
AS $function$
BEGIN
DELETE FROM public."TradeMark_Article"
WHERE
	ArticleId = ArticleId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
