-- ─── PROCEDURE→FUNCTION: integrated_treeiteminsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_treeiteminsert();
CREATE OR REPLACE FUNCTION public.integrated_treeiteminsert(
) RETURNS SETOF record
AS $function$
DECLARE
    id integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	--같은부모를둔 최고높은 정렬번호에 1을 더해준다.

	SELECT  INTO  FROM 	Integrated_TreeItem
	WHERE	PARENTID = ParentID	
	and UserId	=	RegID
	


	
	INSERT INTO Integrated_TreeItem(UserID,Name,ParentID,UseYn,RegID,RegDate,SORTORD,TreeID) 
	RETURN QUERY
	SELECT 
		RegID
	,	Name	
	,	ParentID
	,	UseYn
	,	RegID
	,	NOW()
	, 	COALESCE(SORTORD,0)
	,TreeID
	-- SELECT ID = @IDENTITY	
	RETURN QUERY
	select ParentID;



--------------------------------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
