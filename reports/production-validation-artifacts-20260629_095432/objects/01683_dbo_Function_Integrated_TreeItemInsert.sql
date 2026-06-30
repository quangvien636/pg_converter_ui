-- ─── FUNCTION: integrated_treeiteminsert ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_treeiteminsert();
CREATE OR REPLACE FUNCTION public.integrated_treeiteminsert(
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    id integer;
BEGIN

	--같은부모를둔 최고높은 정렬번호에 1을 더해준다.

	SELECT		SORTORD	= 	MAX(SORTORD) + 1	
	FROM 	Integrated_TreeItem
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
