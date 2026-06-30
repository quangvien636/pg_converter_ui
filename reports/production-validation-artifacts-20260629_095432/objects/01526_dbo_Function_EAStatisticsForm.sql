-- ─── FUNCTION: eastatisticsform ───────────────────────────────
DROP FUNCTION IF EXISTS public.eastatisticsform();
CREATE OR REPLACE FUNCTION public.eastatisticsform(
) RETURNS TABLE(
    id text,
    name text
)
AS $function$
DECLARE
    formid integer;
BEGIN
/*
1.양식별 품의 건수 현황
sort :	부서 / 오름차순
검색 :	기간 검색 from / to
		양식지 선택.
		부서
formid		= 0		--약식지 아이디
depart		= '%'

--양식지 아이디 찾기
	RETURN QUERY
	select id,name from eappform where name ILIKE '%' + '휴가신청서' + '%'
	--사원명으로 부서코드 찾기
	RETURN QUERY
	select orgcd1,public."CMONGETORGANNM"(orgcd1,'1') from cmonusers where usernm1 ILIKE '%' + '관리자' + '%'



	,		depart	varchar(255)	--부서코드
	,		sdate	varchar(10) --시작일
	,		edate	varchar(10) --종료일

	select formid  = 0		--약식지 아이디
	,		depart	= '%'
	,		sdate	= '2008-01-01'--시작일
	,		edate	= '2008-12-30'--종료일

--*/
	

	RETURN QUERY
	SELECT DEPART,NAME,COUNT 
	FROM 
		(			
			
			SELECT	public."CMONGETORGANNM"(D.DEPARTID,'1') AS DEPART,F.NAME,COUNT(1) AS COUNT,1 AS SORT
			FROM	EAPPDOCUMENT D				
					inner JOIN
					(
						select	ID,Name
						from	EAPPFORM F
						where ((formid <> 0 and id = formid) or (formid = 0 and id ILIKE '%'))
					) f
					ON D.FORMID = F.ID				
			WHERE	D.DEPARTID  IS NOT NULL	
			and		(d.state  = 400 or d.state = -4) AND d.progid is not null --종결된문서		
			and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
			and		d.regdate between sdate and edate
			GROUP	BY F.NAME , D.DEPARTID 

			UNION ALL

			SELECT	public."CMONGETORGANNM"(D.DEPARTID,'1'),'부서계',COUNT(1) AS COUNT ,2 AS SORT
			FROM	EAPPDOCUMENT D
					INNER JOIN
					(
						select	ID,Name
						from	EAPPFORM F
						where ((formid <> 0 and id = formid) or (formid = 0 and id ILIKE '%'))
					) f
					ON D.FORMID = F.ID	
			WHERE D.DEPARTID  IS NOT NULL
			and		(d.state  = 400 or d.state = -4) AND d.progid is not null --종결된문서		
			and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
			and		d.regdate between sdate and edate
			GROUP	BY D.DEPARTID 

			UNION ALL		

			SELECT 'Z','전체계',COUNT(1),3
			FROM	EAPPDOCUMENT D		
					INNER JOIN
					(
						select	ID,Name
						from	EAPPFORM F
						where ((formid <> 0 and id = formid) or (formid = 0 and id ILIKE '%'))
					) f
					ON D.FORMID = F.ID			
			WHERE	D.DEPARTID  IS NOT NULL		
			and		(d.state  = 400 or d.state = -4) AND d.progid is not null --종결된문서		
			and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
			and		d.regdate between sdate and edate
		) A
	ORDER BY DEPART,SORT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
