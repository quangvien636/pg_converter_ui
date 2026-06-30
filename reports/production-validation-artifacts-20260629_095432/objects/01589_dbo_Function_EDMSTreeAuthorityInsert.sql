-- ─── FUNCTION: edmstreeauthorityinsert ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmstreeauthorityinsert(character varying, integer);
CREATE OR REPLACE FUNCTION public.edmstreeauthorityinsert(
    userid character varying,
    parentid integer
) RETURNS TABLE(
    divid text,
    folderid text,
    contents text,
    authorityflag text,
    userid text,
    col6 text,
    userid text,
    col8 text,
    parentid text
)
AS $function$
DECLARE
    divid character varying;
    id integer;
BEGIN
	/*	test

,	FolderID		int				--폴더아이디	
,	DepartID		varchar(7999)		--부서코드	
,	Authorityflag	char			--권한플레그 1 : 제외 0 : 포함
,	UserId			varchar(50)
select	DivID			=	'1'
,		FolderID		=	1
,		DepartID		=	'2345;345;345;345;345;345;345345345;'
,		Authorityflag	=	'1'
,		UserId			=	'admin'
	--*/
	begin
	if exists(SELECT FolderID FROM EDMSTreeAuthority where	FolderID = FolderID)
	BEGIN;
		DELETE FROM EDMSTreeAuthority
		where	FolderID = FolderID
	END
	

	INSERT INTO EDMSTreeAuthority
	RETURN QUERY
	SELECT	DivID		
	,		FolderID		
	,		Contents		
	,		Authorityflag
	,		UserId
	,		NOW()
	,		UserId
	,		NOW()
	,		ParentId
	FROM EDMSSplitTable(DepartID,';')


	SET ID = lastval()
	
	RETURN QUERY
	SELECT ID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
