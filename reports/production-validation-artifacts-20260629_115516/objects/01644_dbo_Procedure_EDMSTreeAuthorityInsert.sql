-- ─── PROCEDURE→FUNCTION: edmstreeauthorityinsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmstreeauthorityinsert(character varying, integer);
CREATE OR REPLACE FUNCTION public.edmstreeauthorityinsert(
    IN userid character varying,
    IN parentid integer
) RETURNS SETOF record
AS $function$
DECLARE
    divid character varying;
    id integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test

,	FolderID		int				--폴더아이디	
,	DepartID		varchar(7999)		--부서코드	
,	Authorityflag	char			--권한플레그 1 : 제외 0 : 포함
,	UserId			varchar(50)
DivID := ('1');
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
	END;
	

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


	ID := lastval();
	RETURN QUERY
	SELECT ID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
