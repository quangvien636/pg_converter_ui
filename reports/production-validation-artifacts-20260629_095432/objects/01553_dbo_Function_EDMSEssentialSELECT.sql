-- ─── FUNCTION: edmsessentialselect ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsessentialselect(integer);
CREATE OR REPLACE FUNCTION public.edmsessentialselect(
    docid integer
) RETURNS TABLE(
    data text,
    id text,
    div text
)
AS $function$
DECLARE
    docid integer;
    receive character varying;
BEGIN
	/*	test
RETURN QUERY
SELECT * FROM EDMSSplitTable('8703001;0008018;0209008;9906001;0503007;0208014;',';')
RETURN QUERY
SELECT * FROM EDMSDOCUMENT WHERE ID = 16


		SELECT 			 DocId				= 118			--문서번호
	--*/
	/***************************************************************************
	-- 기본 변수 셋팅
	***************************************************************************/	  

	,		Folder		char(1)
	/***************************************************************************
	-- 권한 관계 뷰
	***************************************************************************/	  
	--수신처 2
	IF EXISTS(
				select	docid 
				from	EDMSReceiveUSER 
				where	docid = edmsessentialselect.docid
			) 			
		OR EXISTS	(
				select	docid
				from	EDMSReceiveORG 
				where	docid = edmsessentialselect.docid
			)
	BEGIN
		SELECT Receive = 'Y' 
	END
	ELSE
	BEGIN
		SELECT Receive = '' 
	END

	--권한 3
	IF EXISTS(
				select	docid 
				from	EDMSAuthUSER 
				where	docid = edmsessentialselect.docid
			)
		OR EXISTS	(
				select	docid
				from	EDMSAuthDepart 
				where	docid = edmsessentialselect.docid
			)
	BEGIN
		SELECT	Auth = 'Y' 
	END
	ELSE
	BEGIN
		SELECT	Auth = '' 
	END
	
	--분류 4
	IF	EXISTS(
				select	docid 
				from	EDMSDocFolder 
				where docid = edmsessentialselect.docid
			  )
	BEGIN
		SELECT	Folder = 'Y' 
	END
	ELSE
	BEGIN
		SELECT	Folder = '' 
	END


	/***************************************************************************
	-- EDMSDOCUMENT select 0
	***************************************************************************/	  
	RETURN QUERY
	select		COALESCE(TITLE,'')							as	TITLE
	,			COALESCE(AUTHORITYLEVEL,'')					as	AUTHORITYLEVEL
	,			'' as DEPARTNAME		
	,			COALESCE(DEPARTID,'')							as	DEPARTID
	,			COALESCE(STOREPERIOD,'')						as	STOREPERIOD
	,			COALESCE(SUMMARY,'')							as	SUMMARY
	,			COALESCE(VERSION,'')							as	VERSION
	,			COALESCE(KEYWORD,'')							as	KEYWORD
	,			Receive									as RECEIVEFLAG
	,			Auth										as AUTHFLAG
	,			Folder										AS FOLDERFLAG
	,			COALESCE(DocLevel,'')							as DocLevel
	from	EDMSDOCUMENT
	WHERE	ID	= edmsessentialselect.docid			
	
	--수신처1		
	RETURN QUERY
	select	Userid as id
	from	EDMSReceiveUSER 
	where	docid = edmsessentialselect.docid

	Union all

	RETURN QUERY
	select	Orgcd as id
	from	EDMSReceiveORG 
	where	docid = edmsessentialselect.docid			

	--권한2
	RETURN QUERY
	select	Userid as id
	from	EDMSAuthUSER 
	where	docid = edmsessentialselect.docid											

	union all

	RETURN QUERY
	select	'(EG)' || Orgcd as id
	from	EDMSAuthDepart 
	where	docid = edmsessentialselect.docid

	--폴더3
	RETURN QUERY
	select	b.ITEMNM1	as Data
	,		a.folderid	AS id
	,		B.DivID as div
	from	EDMSDocFolder A
			inner join
			EDMSTreeItem B
			on a.folderid = b.id and a.divid=b.DivID
	where docid = edmsessentialselect.docid order by B.DivID,B.ID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
