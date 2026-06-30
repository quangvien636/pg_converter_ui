-- ─── PROCEDURE→FUNCTION: trademark_article_delete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
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
