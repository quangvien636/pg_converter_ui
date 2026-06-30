-- ─── PROCEDURE→FUNCTION: edmsessentialselect ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsessentialselect(integer);
CREATE OR REPLACE FUNCTION public.edmsessentialselect(
    IN docid integer
) RETURNS SETOF record
AS $function$
DECLARE
    docid integer;
    receive character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	/*	test
RETURN QUERY
SELECT * FROM EDMSSplitTable('8703001;0008018;0209008;9906001;0503007;0208014;',';')
RETURN QUERY
SELECT * FROM EDMSDOCUMENT WHERE ID = 16


		DocId := (118			--문서번호);
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
		Receive := ('Y');
	END;
	ELSE
		Receive := ('');
	END IF;

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
		Auth := ('Y');
	END;
	ELSE
		Auth := ('');
	END IF;
	
	--분류 4
	IF	EXISTS(
				select	docid 
				from	EDMSDocFolder 
				where docid = edmsessentialselect.docid
			  )
	BEGIN
		Folder := ('Y');
	END;
	ELSE
		Folder := ('');
	END IF;


	/***************************************************************************
	-- EDMSDOCUMENT select 0
	***************************************************************************/	  
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
	select	Userid as id
	from	EDMSReceiveUSER 
	where	docid = edmsessentialselect.docid

	Union all

	select	Orgcd as id
	from	EDMSReceiveORG 
	where	docid = edmsessentialselect.docid			

	--권한2
	select	Userid as id
	from	EDMSAuthUSER 
	where	docid = edmsessentialselect.docid											

	union all

	select	'(EG)' || Orgcd as id
	from	EDMSAuthDepart 
	where	docid = edmsessentialselect.docid

	--폴더3
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
