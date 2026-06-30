-- ─── PROCEDURE→FUNCTION: trademark_article_insert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.trademark_article_insert(character varying, integer, integer, integer, integer, timestamp without time zone, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.trademark_article_insert(
    IN description character varying,
    IN articlekind integer,
    IN status integer,
    IN proid integer,
    IN regno integer,
    IN regdate timestamp without time zone,
    IN modno integer,
    IN moddate timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
INSERT INTO 	public."TradeMark_Article" 
(
				Title,
				Description,
				ArticleKind,
				Status,
				ProId,
				RegNo,
				RegDate,
				ModNo,
				ModDate
) 

VALUES 
(
				Title,
				Description,
				ArticleKind,
				Status,
				ProId,
				RegNo,
				RegDate,
				ModNo,
				ModDate
				
)
RETURN QUERY
SELECT @IDENTITY;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
