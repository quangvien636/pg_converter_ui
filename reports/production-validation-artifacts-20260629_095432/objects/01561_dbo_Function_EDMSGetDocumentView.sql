-- ─── FUNCTION: edmsgetdocumentview ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsgetdocumentview(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsgetdocumentview(
    id integer,
    lang character varying
) RETURNS TABLE(
    saupname text,
    saupcode text
)
AS $function$
DECLARE
    id integer;
BEGIN
/*

--*/
	--리스트 0
	RETURN QUERY
	select 
			TITLE
		,	CONTENT
		,	AUTHORITYLEVEL
		,	STATE
		,	STOREPERIOD
		,	SUMMARY
		,	VERSION
		,	KEYWORD		
		,	CONVERT(VARCHAR(10),regdate,120)	as regdate
		,	CHECKOUTID	--체크아웃한 사람의 아이디.
		,	EADocflag
		,	WRITERID
		,	DocLevel
		,	DEPARTID as DEPTCODE
		,	Serial
	from	EDMSDOCUMENT a
	where id = edmsgetdocumentview.id

	--첨부파일 1	
	RETURN QUERY
	select	ATTACHPATH  
		,	ATTACHNAME	
		,	ATTACHFLAG	
		,	id
		,	Length
 	from	EDMSFILE 
	where	docid = edmsgetdocumentview.id
	and		ispdf = ''

	--수신처 2
	RETURN QUERY
	select	convert(varchar(10),userid)		as cd
		,	'user' as mode
	from	EDMSReceiveUSER 
	where	docid = edmsgetdocumentview.id
	union all
	RETURN QUERY
	select	convert(varchar(10),OrgCd)
		,	'dept' as mode
	from	EDMSReceiveORG 
	where	docid = edmsgetdocumentview.id	

	--권한 3

	RETURN QUERY
	select	convert(varchar(10),userid)		as cd
		,	'user' as mode
	from	EDMSAuthUSER 
	where	docid = edmsgetdocumentview.id
	union all
	RETURN QUERY
	select	'(EG)' || convert(varchar(10),OrgCd)
		,	'dept' as mode
	from	EDMSAuthDepart 
	where	docid = edmsgetdocumentview.id
			
	--분류 4
	RETURN QUERY
	select	case lang when '1' then b.ITEMNM1 when '2' then b.ItemNm2 when '3' then b.ItemNm3 when '4' then b.ItemNm4 else b.ITEMNM1 end as nm
			,	convert(varchar(10),b.id)	as cd,
			B.DivID as div
	from	EDMSDocFolder A
			inner join
			EDMSTreeItem B
			on a.folderid = b.id and a.divid=b.DivID
	where docid = edmsgetdocumentview.id order by B.DivID,B.ID


	--첨부파일 5	PDF
	RETURN QUERY
	select	ATTACHPATH  
		,	ATTACHNAME	
		,	ATTACHFLAG	
		,	id
 	from	EDMSFILE 
	where	docid = edmsgetdocumentview.id
	and		ispdf = 'Y'
	order by id desc

	--첨부파일 6 문서 HTML
	RETURN QUERY
	select	ATTACHPATH  
		,	ATTACHNAME	
		,	ATTACHFLAG	
		,	id
 	from	EDMSFILE 
	where	docid = edmsgetdocumentview.id
	and		ispdf = 'F'
	order by id desc

	--사업장 7
	RETURN QUERY
	select SaupName,SaupCode from EDMS_Saupjang where DocID = edmsgetdocumentview.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
