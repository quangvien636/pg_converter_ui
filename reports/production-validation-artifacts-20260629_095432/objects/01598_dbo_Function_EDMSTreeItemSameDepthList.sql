-- ─── FUNCTION: edmstreeitemsamedepthlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstreeitemsamedepthlist();
CREATE OR REPLACE FUNCTION public.edmstreeitemsamedepthlist(
) RETURNS TABLE(
    id text,
    col2 text,
    sortord text
)
AS $function$
DECLARE
    usergrpcd character varying;
    parentid character varying;
BEGIN
/*

	,	Lang		varchar(1)	--언어선택
	,	Divid		varchar(20) --트리의 종류
	,	UserId		varchar(500) --사용자 아이디
	SELECT 	UserGrpCd = '7'	
	,	Lang = '1'
	,	Divid	= '1'
	,	UserId = ''
--*/
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	--현재그룹의 부모값을 받는다.

	FROM	EDMSTreeItem
	WHERE	ID = UserGrpCd and DivID=Divid
	
	RETURN QUERY
	SELECT 
		ID
	,	CASE  Lang 	WHEN '1' THEN ItemNm1 
				WHEN '2' THEN ItemNm2 
				WHEN '3' THEN ItemNm3 
				WHEN '4' THEN ItemNm4  
				ELSE	 ItemNm1 
		END 	ItemNm
	,	SortOrd 
	FROM  	EDMSTreeItem
	WHERE	ID	>	'0' 
	and (( DIVID = '4' AND 	UserId	=	UserId)	
				OR DIVID IN ('1','2','3') )  
	AND	PARENTID	=	PARENTID
	AND	USEYN		= 	'Y'	
	and	divid		=	divid
	order by SortOrd ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
