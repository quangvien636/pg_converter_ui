-- ─── PROCEDURE→FUNCTION: trademark_article_selectpage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.trademark_article_selectpage(integer);
CREATE OR REPLACE FUNCTION public.trademark_article_selectpage(
    IN pagesize integer
) RETURNS SETOF record
AS $function$
DECLARE
    pagelowerbound integer;
    pageupperbound integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


PageLowerBound := (PageSize * PageNumber) - PageSize;
PageUpperBound := PageLowerBound + PageSize + 1;
RETURN QUERY
SELECT * FROM 
    (SELECT
            ROW_NUMBER() OVER(ORDER BY 
    			ArticleId ASC 
                
            ) AS IndexID,
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
    
    -- WHERE

    -- ORDER BY

    ) AS t
WHERE
    t.IndexID > PageLowerBound 
		AND t.IndexID < PageUpperBound;
-- ORDER BY
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
