-- ─── PROCEDURE→FUNCTION: edmstreeitemdelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.edmstreeitemdelete();
CREATE OR REPLACE FUNCTION public.edmstreeitemdelete(
) RETURNS void
AS $function$
DECLARE
    id character varying;
    sortord integer;
    pid character varying;
    sortordtop integer;
BEGIN
/*


,	FLAG		VARCHAR(1)	-- 1 하위코드를 전부삭제한다. :  하위코드를 최상위루트로 이동한다.
,	DivID		varchar(1)	--트리의  종류
,	UserID		varchar(500) --사용자 아이디
ID := ('10');
,	FLAG		= '1'
,	DivID		= '1'
,	UserID		= '0801008'
--*/
	--삭제될 그룹의 소트번호를뽑는다



	,	PID		= ParentID
	FROM 	EDMSTreeItem 
	WHERE 	ID 	= 	ID and DivID=DivID
	
	--삭제될 그룹의 소트 번호를 0으로 변경한다..;
	UPDATE EDMSTreeItem 
	SORTORD := 0;
	WHERE 	ID = ID and DivID=DivID
	

	--삭제될 그룹과 같은 상위그룹코드를 가지고 보다 높은 소트번호를 가지고 있는 ROW를 -1 해준다. : 소트번호의 순서를 맟추기위해필요.;
	UPDATE EDMSTreeItem 
	SORTORD := SORTORD - 1;
	WHERE 	ParentID = PID
	and	DivID	=	DivID
	and (( DIVID = '4' AND 	UserId	=	UserId)	
				
OR DIVID IN ('1','2') )  
	AND	SORTORD > SORTORD

	
	--삭제대신에 사용정지로 플래그를 변경한다.;
	UPDATE EDMSTreeItem 
	UseYn := '';
	,      SORTORD = NULL
	WHERE ID	=	ID and DivID=DivID
		
	IF FLAG = 1 THEN
		--부모의 바로밑그룹들의 소트번호를뽑아서 그뒤로 붙여준다

		FROM	EDMSTreeItem
		WHERE	ParentID = '0'
		and	DivID	=	DivID
		and (( DIVID = '4' AND 	UserId	=	UserId)	
				OR DIVID IN ('1','2') )  
	
	
	
		--사용불가 표시를할 그룹의 바로밑 그룹을뽑아서 최상위루트의 하위로 붙여준다;
		UPDATE EDMSTreeItem
		ParentID := '0';
		,	SORTORD = SORTORDTOP + SORTORD
		WHERE	ParentID 	=	 ID
		and	DivID	=	DivID
		and (( DIVID = '4' AND 	UserId	=	UserId)	
				OR DIVID IN ('1','2') )  
	END IF;

	/**************************************************************
*************
	-- 분류 테이블 에서의 삭제
	***************************************************************************/	;
	DELETE FROM EDMSDocFolder
	where	folderID = ID and divid=DivID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
