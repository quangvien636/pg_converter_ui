-- ─── PROCEDURE→FUNCTION: edmstreeiteminsert2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmstreeiteminsert2();
CREATE OR REPLACE FUNCTION public.edmstreeiteminsert2(
) RETURNS void
AS $function$
DECLARE
    sortord integer;
BEGIN
	--같은부모를둔 최고높은 정렬번호에 1을 더해준다.

	SELECT  INTO  FROM 	EDMSTreeItem
	WHERE	PARENTID = ParentID
	AND		DIVID	=	DIVID
	and (( DIVID = '4' AND 	UserId	=	RegID)	
				OR DIVID IN ('1','2') )  
	


	
	INSERT INTO EDMSTreeItem(UserID,ItemNm1,ItemNm2,ItemNm3,ItemNm4,ParentID,UseYn,RegID,RegDate,DivID,SORTORD,ID,StorePeriod) 
	SELECT 
		RegID
	,	ItemNm1
	,	ItemNm2
	,	ItemNm3
	,	ItemNm4
	,	ParentID
	,	UseYn
	,	RegID
	,	NOW()
	,	DivID
	, 	COALESCE(SORTORD,0)
	,	TreeID
	,	StorePeriod;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
