-- ─── FUNCTION: photoboardgetprevnextboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardgetprevnextboard(integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardgetprevnextboard(
    id integer,
    langindex integer
) RETURNS TABLE(
    rownum text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

 with tmp  as (Select * , ROW_NUMBER() OVER (ORDER BY ID) AS RowNum from PhotoBoard)
 
,tmp_UserName as (Select *, '' as UserName from tmp)

RETURN QUERY
SELECT /* TOP 3 */ * 
    FROM  tmp_UserName
    WHERE tmp_UserName.RowNum >=
        (
            SELECT 
			RowNum 
			FROM tmp_UserName where tmp_UserName.ID=photoboardgetprevnextboard.id
        ) -1
    ORDER BY tmp_UserName.RowNum;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
