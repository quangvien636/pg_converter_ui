-- ─── PROCEDURE→FUNCTION: photoboardallselect ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.photoboardallselect(integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.photoboardallselect(
    IN fpage integer,
    IN tpage integer,
    IN userid character varying,
    IN langindex integer
) RETURNS SETOF record
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
