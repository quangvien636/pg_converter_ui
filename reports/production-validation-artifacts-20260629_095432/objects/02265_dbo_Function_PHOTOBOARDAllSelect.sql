-- ─── FUNCTION: photoboardallselect ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardallselect(integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.photoboardallselect(
    fpage integer,
    tpage integer,
    userid character varying,
    langindex integer
) RETURNS TABLE(
    id text,
    title text,
    content text,
    writerid text,
    username text,
    positionid text,
    positionname text,
    departid text,
    departname text,
    worder text,
    wlevel text,
    wgroup text,
    hit text,
    regdate text,
    moddate text,
    sortno text,
    filename text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 
	
	RETURN QUERY
	SELECT * FROM (
	SELECT ID,Title,Content,WriterID,'' as UserName,
	  PositionID,
	  '' as PositionName,
	  DepartID,
	  '' as DepartName,
	  WOrder,WLevel,WGroup,Hit,RegDate,ModDate
	, ROW_NUMBER() OVER(ORDER BY ID DESC) AS SortNo,
	(Select /* TOP 1 */ PF.FileName from PhotoBoardFile PF where PF.ParentID = PB.ID and PF.FirstFlag =1) as FileName,
	COUNT(*) OVER() AS TOTALCOUNT
	FROM PhotoBoard PB 
	) AS TMP
	WHERE SortNo BETWEEN FPAGE AND TPAGE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
