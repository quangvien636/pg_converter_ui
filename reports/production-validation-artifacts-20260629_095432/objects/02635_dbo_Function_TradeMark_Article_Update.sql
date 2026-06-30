-- ─── FUNCTION: trademark_article_update ───────────────────────────────
DROP FUNCTION IF EXISTS public.trademark_article_update(character varying, character varying, integer, integer, integer, integer, timestamp without time zone, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.trademark_article_update(
    title character varying,
    description character varying,
    articlekind integer,
    status integer,
    proid integer,
    regno integer,
    regdate timestamp without time zone,
    modno integer,
    moddate timestamp without time zone
) RETURNS void
AS $function$
BEGIN
UPDATE 		public."TradeMark_Article" 

SET
			Title = trademark_article_update.title,
			Description = trademark_article_update.description,
			ArticleKind = trademark_article_update.articlekind,
			Status = trademark_article_update.status,
			ProId = trademark_article_update.proid,
			RegNo = trademark_article_update.regno,
			RegDate = trademark_article_update.regdate,
			ModNo = trademark_article_update.modno,
			ModDate = trademark_article_update.moddate
			
WHERE
			ArticleId = ArticleId;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
