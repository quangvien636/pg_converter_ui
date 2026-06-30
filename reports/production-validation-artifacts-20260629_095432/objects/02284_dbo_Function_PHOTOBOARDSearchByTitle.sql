-- ─── FUNCTION: photoboardsearchbytitle ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardsearchbytitle(character varying, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.photoboardsearchbytitle(
    text character varying,
    userid character varying,
    langindex integer,
    searchtype character varying
) RETURNS TABLE(
    parentid text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF searchType = 'TITLE' 
begin
 RETURN QUERY
 SELECT * FROM (
	SELECT ID,Title,Content,WriterID,'' as UserName,
	  PositionID,DepartID,WOrder,WLevel,WGroup,Hit,RegDate,ModDate,
	(Select /* TOP 1 */ PF.FileName from PhotoBoardFile PF where PF.ParentID = PB.ID and PF.FirstFlag =1) as FileName,
	COUNT(*) OVER() AS TOTALCOUNT
	FROM PhotoBoard PB
	Where --WriterID = USERID and 
		  Title ILIKE '%' || Text || '%'
	) AS TMP  
end;
else if searchType = 'CONTENT'
	begin
	RETURN QUERY
	SELECT * FROM (
	SELECT ID,Title,Content,WriterID,'' as UserName,
	  PositionID,DepartID,WOrder,WLevel,WGroup,Hit,RegDate,ModDate,
	(Select /* TOP 1 */ PF.FileName from PhotoBoardFile PF where PF.ParentID = PB.ID and PF.FirstFlag =1) as FileName,
	COUNT(*) OVER() AS TOTALCOUNT
	FROM PhotoBoard PB
	Where 
		  Content ILIKE '%' || Text || '%'
	) AS TMP  
	end;
else if searchType = 'WRITERNAME'
	begin
	RETURN QUERY
	SELECT * FROM (
	SELECT ID,Title,Content,WriterID,'' as UserName,
	  PositionID,DepartID,WOrder,WLevel,WGroup,Hit,RegDate,ModDate,
	(Select /* TOP 1 */ PF.FileName from PhotoBoardFile PF where PF.ParentID = PB.ID and PF.FirstFlag =1) as FileName,
	COUNT(*) OVER() AS TOTALCOUNT
	FROM PhotoBoard PB
	Where 
		  WriterID ILIKE '%' || Text || '%'
	) AS TMP  
	end;
else if searchType = 'FILENAME'
	begin
	RETURN QUERY
	SELECT * FROM (
	SELECT ID,Title,Content,WriterID,'' as UserName,
	  PositionID,DepartID,WOrder,WLevel,WGroup,Hit,RegDate,ModDate,
	(Select /* TOP 1 */ PF.FileName from PhotoBoardFile PF where PF.ParentID = PB.ID and PF.FirstFlag =1) as FileName,
	COUNT(*) OVER() AS TOTALCOUNT
	FROM PhotoBoard PB
	Where 
		  ID IN (SELECT ParentID FROM PhotoBoardFile WHERE  FileName ILIKE '%' || Text || '%')
	) AS TMP  
	end;
else
	begin
	RETURN QUERY
	SELECT * FROM (
	SELECT ID,Title,Content,WriterID,'' as UserName,
	  PositionID,DepartID,WOrder,WLevel,WGroup,Hit,RegDate,ModDate,
	(Select /* TOP 1 */ PF.FileName from PhotoBoardFile PF where PF.ParentID = PB.ID and PF.FirstFlag =1) as FileName,
	COUNT(*) OVER() AS TOTALCOUNT
	FROM PhotoBoard PB
	Where --WriterID = USERID and 
		  Title ILIKE '%' || Text || '%'
		  OR
		  Content ILIKE '%' || Text || '%'
		  OR
		  ID IN (SELECT ParentID FROM PhotoBoardFile WHERE  FileName ILIKE '%' || Text || '%')
		  OR
		  WriterID  ILIKE '%' || Text || '%'
		  
	) AS TMP  
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
