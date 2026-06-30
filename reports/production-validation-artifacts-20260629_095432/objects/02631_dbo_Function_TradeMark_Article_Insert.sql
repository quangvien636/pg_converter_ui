-- ─── FUNCTION: trademark_article_insert ───────────────────────────────
DROP FUNCTION IF EXISTS public.trademark_article_insert(character varying, integer, integer, integer, integer, timestamp without time zone, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.trademark_article_insert(
    description character varying,
    articlekind integer,
    status integer,
    proid integer,
    regno integer,
    regdate timestamp without time zone,
    modno integer,
    moddate timestamp without time zone
) RETURNS TABLE(
    col1 text
)
AS $function$
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
