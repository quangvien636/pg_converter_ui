-- ─── FUNCTION: trademark_article_selectpage ───────────────────────────────
DROP FUNCTION IF EXISTS public.trademark_article_selectpage(integer);
CREATE OR REPLACE FUNCTION public.trademark_article_selectpage(
    pagesize integer
) RETURNS TABLE(
    indexid text,
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
DECLARE
    pagelowerbound integer;
    pageupperbound integer;
BEGIN


SET PageLowerBound = (PageSize * PageNumber) - PageSize
SET PageUpperBound = PageLowerBound + PageSize + 1

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
