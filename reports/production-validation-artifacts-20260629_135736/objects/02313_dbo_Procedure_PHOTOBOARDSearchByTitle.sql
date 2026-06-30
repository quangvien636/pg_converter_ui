-- ─── PROCEDURE→FUNCTION: photoboardsearchbytitle ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.photoboardsearchbytitle(character varying, character varying, integer, character varying);
CREATE OR REPLACE FUNCTION public.photoboardsearchbytitle(
    IN text character varying,
    IN userid character varying,
    IN langindex integer,
    IN searchtype character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

IF searchType = 'TITLE' THEN
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
END IF;
ELSIF searchType = 'CONTENT' THEN
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
	END IF;
ELSIF searchType = 'WRITERNAME' THEN
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
	END IF;
ELSIF searchType = 'FILENAME' THEN
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
	END IF;
ELSE
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
