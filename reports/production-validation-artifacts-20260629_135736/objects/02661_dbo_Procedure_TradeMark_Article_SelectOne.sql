-- ─── PROCEDURE→FUNCTION: trademark_article_selectone ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.trademark_article_selectone();
CREATE OR REPLACE FUNCTION public.trademark_article_selectone(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
		public."TradeMark_Article"
		
WHERE
		ArticleId = ArticleId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
