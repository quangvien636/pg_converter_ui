-- ─── PROCEDURE→FUNCTION: eastatisticsusertime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.eastatisticsusertime(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eastatisticsusertime(
    IN formid integer,
    IN sdate character varying,
    IN edate character varying
) RETURNS SETOF record
AS $function$
DECLARE
    formid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*
	직원별	결재 건수 현황,직원별 평균 결재 시간 현황		
	Sort :	건수 / 내림차순
	검색 :	기간 from / to 기안일
			양식지(보류)
			부서

formid = 0 이면 전체

--양식지 아이디 찾기
	RETURN QUERY
	select id,name from eappform where name ILIKE '%' + '양식명 넣는곳' + '%'
	--사원명으로 부서코드 찾기
	RETURN QUERY
	select orgcd1 from cmonusers where usernm1 ILIKE '%' + '사원명 넣는곳' + '%'


	,		sdate		varchar(10)
	,		edate		varchar(10)

	formid := (0);
	,		depart		= '%'
	,		sdate		= '2008-09-01'
	,		edate		= '2008-10-31'

--*/
	

	RETURN QUERY
	SELECT DEFART,USERNAME ,COUNT,AVGDIFFDATE
	FROM 
		(
			SELECT	public."CMONGETORGANNM"(DEPARTID,'1') AS DEFART,public."CMONGETUSERNM"(WRITERID,'1') AS USERNAME,COUNT(1) AS COUNT, AVG(DIFFDATE) AS AVGDIFFDATE,1 SORT		
			FROM	EAPPDOCUMENT D
					INNER JOIN
					(
						SELECT A.ID,(MANAGEDATE::date - A.regDate::date)+1 AS DIFFDATE 
						FROM EAPPDOCUMENT A
						INNER JOIN
						(
							SELECT MAX(MANAGEDATE) AS MANAGEDATE , DOCUMENTID
							FROM EAPPPROGRESS B 
							WHERE accesstype in (1,2,11)
							GROUP BY DOCUMENTID
						) B
						ON A.ID = B.DOCUMENTID 																				
						where	(A.State  = 400 or A.State = -4) and A.progid is not null --종결된문서	
						and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
						and		a.regdate between sdate and edate
						and		((formid <> 0 and formid = eastatisticsusertime.formid) or (formid = 0 and formid ILIKE '%'))
					) A
					ON D.ID = A.ID
			WHERE	D.WRITERID  IS NOT NULL				
			GROUP BY WRITERID,DEPARTID

			UNION ALL

			SELECT	'전체계','',COUNT(1) AS COUNT ,AVG(DIFFDATE) AS AVGDIFFDATE ,2 SORT		
			FROM	EAPPDOCUMENT D
					INNER JOIN
					(
						SELECT A.ID,(MANAGEDATE::date - A.regDate::date)+1 AS DIFFDATE 
						FROM EAPPDOCUMENT A
						INNER JOIN
						(
							SELECT MAX(MANAGEDATE) AS MANAGEDATE , DOCUMENTID
							FROM EAPPPROGRESS B
							WHERE accesstype in (1,2,11)
							GROUP BY DOCUMENTID
						) B
						ON A.ID = B.DOCUMENTID 		
						where (A.State  = 400 or A.State = -4) and A.progid is not null --종결된문서	
						and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
						and		regdate between sdate and edate							
						and		((formid <> 0 and formid = eastatisticsusertime.formid) or (formid = 0 and formid ILIKE '%'))
					) A
					ON D.ID = A.ID
			WHERE	WRITERID  IS NOT NULL		
		) A
	ORDER BY SORT , COUNT DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
