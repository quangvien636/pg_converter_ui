-- ─── FUNCTION: eastatisticstime ───────────────────────────────
DROP FUNCTION IF EXISTS public.eastatisticstime();
CREATE OR REPLACE FUNCTION public.eastatisticstime(
) RETURNS TABLE(
    id text
)
AS $function$
DECLARE
    formid integer;
BEGIN
/*
	당월 시간별 결재 현황
	Sort :	부서 / 오름차순
	검색 :	기간(기안일 from : to)
			부서
			양식

	formid = 0 이면 전체	
	depart	= '%' 이면 전체

	doccount : 기안 건수
	procount : 결재건수

	--양식지 아이디 찾기
	RETURN QUERY
	select id,name from eappform where name ILIKE '%' + '양식명 넣는곳' + '%'
	--사원명으로 부서코드 찾기
	RETURN QUERY
	select orgcd1 from cmonusers where usernm1 ILIKE '%' + '사원명 넣는곳' + '%'


	,		depart	varchar(255)	--부서코드
	,		sdate	varchar(10) --시작일
	,		edate	varchar(10) --종료일

	select formid = 0		--양식지 아이디
	,		depart	= '%'
	,		sdate	= '2008-01-01'--시작일
	,		edate	= '2009-02-28'--종료일

--*/
	

	RETURN QUERY
	SELECT *, '자세히 보기' as detail
	FROM	(
		select depart,public."CMONGETUSERNM"(writerid,'1') as writerid,	doccount1 ,	 procount1 ,	doccount2 ,	 procount2 ,	doccount3 ,	 procount3 ,	doccount4 ,	 procount4 ,	doccount5 ,	 procount5 ,	doccount6 ,	 procount6 ,	doccount7 ,	 procount7 ,	doccount8 ,	 procount8 ,	doccount9 ,	 procount9  ,doccount10 , procount10 ,doccount11 , procount11 ,doccount12 , procount12 ,doccount13 , procount13 ,doccount14 , procount14 ,doccount15 , procount15 ,doccount16 , procount16 ,doccount17 , procount17 ,doccount18 , procount18 ,doccount19 , procount19 ,doccount20 , procount20 ,doccount21 , procount21 ,doccount22 , procount22 ,doccount23 , procount23 ,doccount24,procount24, 1 as sortno
		from (	
			select public."CMONGETORGANNM"(DEPARTID,'1') AS DEPART,WRITERID
					,	sum(case when datepart(HOUR,regdate) = 1 then 1 else 0 end) as doccount1
					,	sum(case when datepart(HOUR,regdate) = 2 then 1 else 0 end) as doccount2
					,	sum(case when datepart(HOUR,regdate) = 3 then 1 else 0 end) as doccount3
					,	sum(case when datepart(HOUR,regdate) = 4 then 1 else 0 end) as doccount4
					,	sum(case when datepart(HOUR,regdate) = 5 then 1 else 0 end) as doccount5
					,	sum(case when datepart(HOUR,regdate) = 6 then 1 else 0 end) as doccount6
					,	sum(case when datepart(HOUR,regdate) = 7 then 1 else 0 end) as doccount7
					,	sum(case when datepart(HOUR,regdate) = 8 then 1 else 0 end) as doccount8
					,	sum(case when datepart(HOUR,regdate) = 9 then 1 else 0 end) as doccount9
					,	sum(case when datepart(HOUR,regdate) = 10 then 1 else 0 end) as doccount10
					,	sum(case when datepart(HOUR,regdate) = 11 then 1 else 0 end) as doccount11
					,	sum(case when datepart(HOUR,regdate) = 12 then 1 else 0 end) as doccount12
					,	sum(case when datepart(HOUR,regdate) = 13 then 1 else 0 end) as doccount13
					,	sum(case when datepart(HOUR,regdate) = 14 then 1 else 0 end) as doccount14
					,	sum(case when datepart(HOUR,regdate) = 15 then 1 else 0 end) as doccount15
					,	sum(case when datepart(HOUR,regdate) = 16 then 1 else 0 end) as doccount16
					,	sum(case when datepart(HOUR,regdate) = 17 then 1 else 0 end) as doccount17
					,	sum(case when datepart(HOUR,regdate) = 18 then 1 else 0 end) as doccount18
					,	sum(case when datepart(HOUR,regdate) = 19 then 1 else 0 end) as doccount19
					,	sum(case when datepart(HOUR,regdate) = 20 then 1 else 0 end) as doccount20
					,	sum(case when datepart(HOUR,regdate) = 21 then 1 else 0 end) as doccount21
					,	sum(case when datepart(HOUR,regdate) = 22 then 1 else 0 end) as doccount22
					,	sum(case when datepart(HOUR,regdate) = 23 then 1 else 0 end) as doccount23
					,	sum(case when datepart(HOUR,regdate) = 24 then 1 else 0 end) as doccount24					
			from	eappdocument d
			where	(d.state  = 400 or d.state = -4) and d.progid is not null --종결된문서
			and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
			and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
			and		regdate between sdate and edate	
			group by departid,writerid
		) a 
		inner join
		(
			select ManagerID
				,	sum(case when datepart(HOUR,ManageDate) = 1 then 1 else 0 end) as procount1
				,	sum(case when datepart(HOUR,ManageDate) = 2 then 1 else 0 end) as procount2
				,	sum(case when datepart(HOUR,ManageDate) = 3 then 1 else 0 end) as procount3
				,	sum(case when datepart(HOUR,ManageDate) = 4 then 1 else 0 end) as procount4
				,	sum(case when datepart(HOUR,ManageDate) = 5 then 1 else 0 end) as procount5
				,	sum(case when datepart(HOUR,ManageDate) = 6 then 1 else 0 end) as procount6
				,	sum(case when datepart(HOUR,ManageDate) = 7 then 1 else 0 end) as procount7
				,	sum(case when datepart(HOUR,ManageDate) = 8 then 1 else 0 end) as procount8
				,	sum(case when datepart(HOUR,ManageDate) = 9 then 1 else 0 end) as procount9
				,	sum(case when datepart(HOUR,ManageDate) = 10 then 1 else 0 end) as procount10
				,	sum(case when datepart(HOUR,ManageDate) = 11 then 1 else 0 end) as procount11
				,	sum(case when datepart(HOUR,ManageDate) = 12 then 1 else 0 end) as procount12
				,	sum(case when datepart(HOUR,ManageDate) = 13 then 1 else 0 end) as procount13
				,	sum(case when datepart(HOUR,ManageDate) = 14 then 1 else 0 end) as procount14
				,	sum(case when datepart(HOUR,ManageDate) = 15 then 1 else 0 end) as procount15
				,	sum(case when datepart(HOUR,ManageDate) = 16 then 1 else 0 end) as procount16
				,	sum(case when datepart(HOUR,ManageDate) = 17 then 1 else 0 end) as procount17
				,	sum(case when datepart(HOUR,ManageDate) = 18 then 1 else 0 end) as procount18
				,	sum(case when datepart(HOUR,ManageDate) = 19 then 1 else 0 end) as procount19
				,	sum(case when datepart(HOUR,ManageDate) = 20 then 1 else 0 end) as procount20
				,	sum(case when datepart(HOUR,ManageDate) = 21 then 1 else 0 end) as procount21
				,	sum(case when datepart(HOUR,ManageDate) = 22 then 1 else 0 end) as procount22
				,	sum(case when datepart(HOUR,ManageDate) = 23 then 1 else 0 end) as procount23
				,	sum(case when datepart(HOUR,ManageDate) = 24 then 1 else 0 end) as procount24				
			from	eappprogress p
					inner join
					(
						select	id 
						from	eappdocument d
						where	(d.state  = 400 or d.state = -4) and d.progid is not null
						and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
						and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
						and		regdate between sdate and edate				
					) d
					on p.DocumentID = d.id		
			where p.accesstype in (1,2,11)
			group by ManagerID
		)b 
		on a.WRITERID = b.managerid

		union all

		select	depart,'부서계',	sum(doccount1) ,	 sum(procount1) ,	sum(doccount2) ,	 sum(procount2) ,	sum(doccount3) ,	 sum(procount3) ,	sum(doccount4) ,	 sum(procount4) ,	sum(doccount5) ,	 sum(procount5) ,	sum(doccount6) ,	 sum(procount6) ,	sum(doccount7) ,	 sum(procount7) ,	sum(doccount8) ,	 sum(procount8) ,	sum(doccount9) ,	 sum(procount9)  ,sum(doccount10) , sum(procount10) ,sum(doccount11) , sum(procount11) ,sum(doccount12) , sum(procount12) ,sum(doccount13) , sum(procount13) ,sum(doccount14) , sum(procount14) ,sum(doccount15) , sum(procount15) ,sum(doccount16) , sum(procount16) ,sum(doccount17) , sum(procount17) ,sum(doccount18) , sum(procount18) ,sum(doccount19) , sum(procount19) ,sum(doccount20) , sum(procount20) ,sum(doccount21) , sum(procount21) ,sum(doccount22) , sum(procount22) ,sum(doccount23) , sum(procount23) ,sum(doccount24) , sum(procount24), 2 as sortno
		from	(
			select depart,WRITERID,	doccount1 ,	 procount1 ,	doccount2 ,	 procount2 ,	doccount3 ,	 procount3 ,	doccount4 ,	 procount4 ,	doccount5 ,	 procount5 ,	doccount6 ,	 procount6 ,	doccount7 ,	 procount7 ,	doccount8 ,	 procount8 ,	doccount9 ,	 procount9  ,doccount10 , procount10 ,doccount11 , procount11 ,doccount12 , procount12 ,doccount13 , procount13 ,doccount14 , procount14 ,doccount15 , procount15 ,doccount16 , procount16 ,doccount17 , procount17 ,doccount18 , procount18 ,doccount19 , procount19 ,doccount20 , procount20 ,doccount21 , procount21 ,doccount22 , procount22 ,doccount23 , procount23 ,doccount24,procount24
			from (	
				select public."CMONGETORGANNM"(DEPARTID,'1') AS DEPART,WRITERID
						,	sum(case when datepart(HOUR,regdate) = 1 then 1 else 0 end) as doccount1
						,	sum(case when datepart(HOUR,regdate) = 2 then 1 else 0 end) as doccount2
						,	sum(case when datepart(HOUR,regdate) = 3 then 1 else 0 end) as doccount3
						,	sum(case when datepart(HOUR,regdate) = 4 then 1 else 0 end) as doccount4
						,	sum(case when datepart(HOUR,regdate) = 5 then 1 else 0 end) as doccount5
						,	sum(case when datepart(HOUR,regdate) = 6 then 1 else 0 end) as doccount6
						,	sum(case when datepart(HOUR,regdate) = 7 then 1 else 0 end) as doccount7
						,	sum(case when datepart(HOUR,regdate) = 8 then 1 else 0 end) as doccount8
						,	sum(case when datepart(HOUR,regdate) = 9 then 1 else 0 end) as doccount9
						,	sum(case when datepart(HOUR,regdate) = 10 then 1 else 0 end) as doccount10
						,	sum(case when datepart(HOUR,regdate) = 11 then 1 else 0 end) as doccount11
						,	sum(case when datepart(HOUR,regdate) = 12 then 1 else 0 end) as doccount12
						,	sum(case when datepart(HOUR,regdate) = 13 then 1 else 0 end) as doccount13
						,	sum(case when datepart(HOUR,regdate) = 14 then 1 else 0 end) as doccount14
						,	sum(case when datepart(HOUR,regdate) = 15 then 1 else 0 end) as doccount15
						,	sum(case when datepart(HOUR,regdate) = 16 then 1 else 0 end) as doccount16
						,	sum(case when datepart(HOUR,regdate) = 17 then 1 else 0 end) as doccount17
						,	sum(case when datepart(HOUR,regdate) = 18 then 1 else 0 end) as doccount18
						,	sum(case when datepart(HOUR,regdate) = 19 then 1 else 0 end) as doccount19
						,	sum(case when datepart(HOUR,regdate) = 20 then 1 else 0 end) as doccount20
						,	sum(case when datepart(HOUR,regdate) = 21 then 1 else 0 end) as doccount21
						,	sum(case when datepart(HOUR,regdate) = 22 then 1 else 0 end) as doccount22
						,	sum(case when datepart(HOUR,regdate) = 23 then 1 else 0 end) as doccount23
						,	sum(case when datepart(HOUR,regdate) = 24 then 1 else 0 end) as doccount24
				from	eappdocument d
				where	(d.state  = 400 or d.state = -4) and d.progid is not null --종결된문서
				and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
				and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
				and		regdate between sdate and edate	
				group by departid,writerid
			) a 
			inner join
			(
				select ManagerID
					,	sum(case when datepart(HOUR,ManageDate) = 1 then 1 else 0 end) as procount1
					,	sum(case when datepart(HOUR,ManageDate) = 2 then 1 else 0 end) as procount2
					,	sum(case when datepart(HOUR,ManageDate) = 3 then 1 else 0 end) as procount3
					,	sum(case when datepart(HOUR,ManageDate) = 4 then 1 else 0 end) as procount4
					,	sum(case when datepart(HOUR,ManageDate) = 5 then 1 else 0 end) as procount5
					,	sum(case when datepart(HOUR,ManageDate) = 6 then 1 else 0 end) as procount6
					,	sum(case when datepart(HOUR,ManageDate) = 7 then 1 else 0 end) as procount7
					,	sum(case when datepart(HOUR,ManageDate) = 8 then 1 else 0 end) as procount8
					,	sum(case when datepart(HOUR,ManageDate) = 9 then 1 else 0 end) as procount9
					,	sum(case when datepart(HOUR,ManageDate) = 10 then 1 else 0 end) as procount10
					,	sum(case when datepart(HOUR,ManageDate) = 11 then 1 else 0 end) as procount11
					,	sum(case when datepart(HOUR,ManageDate) = 12 then 1 else 0 end) as procount12
					,	sum(case when datepart(HOUR,ManageDate) = 13 then 1 else 0 end) as procount13
					,	sum(case when datepart(HOUR,ManageDate) = 14 then 1 else 0 end) as procount14
					,	sum(case when datepart(HOUR,ManageDate) = 15 then 1 else 0 end) as procount15
					,	sum(case when datepart(HOUR,ManageDate) = 16 then 1 else 0 end) as procount16
					,	sum(case when datepart(HOUR,ManageDate) = 17 then 1 else 0 end) as procount17
					,	sum(case when datepart(HOUR,ManageDate) = 18 then 1 else 0 end) as procount18
					,	sum(case when datepart(HOUR,ManageDate) = 19 then 1 else 0 end) as procount19
					,	sum(case when datepart(HOUR,ManageDate) = 20 then 1 else 0 end) as procount20
					,	sum(case when datepart(HOUR,ManageDate) = 21 then 1 else 0 end) as procount21
					,	sum(case when datepart(HOUR,ManageDate) = 22 then 1 else 0 end) as procount22
					,	sum(case when datepart(HOUR,ManageDate) = 23 then 1 else 0 end) as procount23
					,	sum(case when datepart(HOUR,ManageDate) = 24 then 1 else 0 end) as procount24		
				from	eappprogress p
						inner join
						(
							select	id 
							from	eappdocument d
							where	(d.state  = 400 or d.state = -4) and d.progid is not null
							and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
							and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
							and		regdate between sdate and edate				
						) d
						on p.DocumentID = d.id		
				where p.accesstype in (1,2,11)
				group by ManagerID
			)b 
			on a.WRITERID = b.managerid
		) a
		group by depart


		union all

		select	'Z','전체계',	sum(doccount1) ,	 sum(procount1) ,	sum(doccount2) ,	 sum(procount2) ,	sum(doccount3) ,	 sum(procount3) ,	sum(doccount4) ,	 sum(procount4) ,	sum(doccount5) ,	 sum(procount5) ,	sum(doccount6) ,	 sum(procount6) ,	sum(doccount7) ,	 sum(procount7) ,	sum(doccount8) ,	 sum(procount8) ,	sum(doccount9) ,	 sum(procount9)  ,sum(doccount10) , sum(procount10) ,sum(doccount11) , sum(procount11) ,sum(doccount12) , sum(procount12) ,sum(doccount13) , sum(procount13) ,sum(doccount14) , sum(procount14) ,sum(doccount15) , sum(procount15) ,sum(doccount16) , sum(procount16) ,sum(doccount17) , sum(procount17) ,sum(doccount18) , sum(procount18) ,sum(doccount19) , sum(procount19) ,sum(doccount20) , sum(procount20) ,sum(doccount21) , sum(procount21) ,sum(doccount22) , sum(procount22) ,sum(doccount23) , sum(procount23) ,sum(doccount24),sum(procount24), 3 as sortno
		from	(
			select depart,WRITERID,	doccount1 ,	 procount1 ,	doccount2 ,	 procount2 ,	doccount3 ,	 procount3 ,	doccount4 ,	 procount4 ,	doccount5 ,	 procount5 ,	doccount6 ,	 procount6 ,	doccount7 ,	 procount7 ,	doccount8 ,	 procount8 ,	doccount9 ,	 procount9  ,doccount10 , procount10 ,doccount11 , procount11 ,doccount12 , procount12 ,doccount13 , procount13 ,doccount14 , procount14 ,doccount15 , procount15 ,doccount16 , procount16 ,doccount17 , procount17 ,doccount18 , procount18 ,doccount19 , procount19 ,doccount20 , procount20 ,doccount21 , procount21 ,doccount22 , procount22 ,doccount23 , procount23 ,doccount24,procount24
			from (	
				select public."CMONGETORGANNM"(DEPARTID,'1') AS DEPART,WRITERID
						,	sum(case when datepart(HOUR,regdate) = 1 then 1 else 0 end) as doccount1
						,	sum(case when datepart(HOUR,regdate) = 2 then 1 else 0 end) as doccount2
						,	sum(case when datepart(HOUR,regdate) = 3 then 1 else 0 end) as doccount3
						,	sum(case when datepart(HOUR,regdate) = 4 then 1 else 0 end) as doccount4
						,	sum(case when datepart(HOUR,regdate) = 5 then 1 else 0 end) as doccount5
						,	sum(case when datepart(HOUR,regdate) = 6 then 1 else 0 end) as doccount6
						,	sum(case when datepart(HOUR,regdate) = 7 then 1 else 0 end) as doccount7
						,	sum(case when datepart(HOUR,regdate) = 8 then 1 else 0 end) as doccount8
						,	sum(case when datepart(HOUR,regdate) = 9 then 1 else 0 end) as doccount9
						,	sum(case when datepart(HOUR,regdate) = 10 then 1 else 0 end) as doccount10
						,	sum(case when datepart(HOUR,regdate) = 11 then 1 else 0 end) as doccount11
						,	sum(case when datepart(HOUR,regdate) = 12 then 1 else 0 end) as doccount12
						,	sum(case when datepart(HOUR,regdate) = 13 then 1 else 0 end) as doccount13
						,	sum(case when datepart(HOUR,regdate) = 14 then 1 else 0 end) as doccount14
						,	sum(case when datepart(HOUR,regdate) = 15 then 1 else 0 end) as doccount15
						,	sum(case when datepart(HOUR,regdate) = 16 then 1 else 0 end) as doccount16
						,	sum(case when datepart(HOUR,regdate) = 17 then 1 else 0 end) as doccount17
						,	sum(case when datepart(HOUR,regdate) = 18 then 1 else 0 end) as doccount18
						,	sum(case when datepart(HOUR,regdate) = 19 then 1 else 0 end) as doccount19
						,	sum(case when datepart(HOUR,regdate) = 20 then 1 else 0 end) as doccount20
						,	sum(case when datepart(HOUR,regdate) = 21 then 1 else 0 end) as doccount21
						,	sum(case when datepart(HOUR,regdate) = 22 then 1 else 0 end) as doccount22
						,	sum(case when datepart(HOUR,regdate) = 23 then 1 else 0 end) as doccount23
						,	sum(case when datepart(HOUR,regdate) = 24 then 1 else 0 end) as doccount24		
				from	eappdocument d
				where	(d.state  = 400 or d.state = -4) and d.progid is not null--종결된문서
				and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
				and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
				and		regdate between sdate and edate	
				group by departid,writerid
			) a 
			inner join
			(
				select ManagerID
					,	sum(case when datepart(HOUR,ManageDate) = 1 then 1 else 0 end) as procount1
					,	sum(case when datepart(HOUR,ManageDate) = 2 then 1 else 0 end) as procount2
					,	sum(case when datepart(HOUR,ManageDate) = 3 then 1 else 0 end) as procount3
					,	sum(case when datepart(HOUR,ManageDate) = 4 then 1 else 0 end) as procount4
					,	sum(case when datepart(HOUR,ManageDate) = 5 then 1 else 0 end) as procount5
					,	sum(case when datepart(HOUR,ManageDate) = 6 then 1 else 0 end) as procount6
					,	sum(case when datepart(HOUR,ManageDate) = 7 then 1 else 0 end) as procount7
					,	sum(case when datepart(HOUR,ManageDate) = 8 then 1 else 0 end) as procount8
					,	sum(case when datepart(HOUR,ManageDate) = 9 then 1 else 0 end) as procount9
					,	sum(case when datepart(HOUR,ManageDate) = 10 then 1 else 0 end) as procount10
					,	sum(case when datepart(HOUR,ManageDate) = 11 then 1 else 0 end) as procount11
					,	sum(case when datepart(HOUR,ManageDate) = 12 then 1 else 0 end) as procount12
					,	sum(case when datepart(HOUR,ManageDate) = 13 then 1 else 0 end) as procount13
					,	sum(case when datepart(HOUR,ManageDate) = 14 then 1 else 0 end) as procount14
					,	sum(case when datepart(HOUR,ManageDate) = 15 then 1 else 0 end) as procount15
					,	sum(case when datepart(HOUR,ManageDate) = 16 then 1 else 0 end) as procount16
					,	sum(case when datepart(HOUR,ManageDate) = 17 then 1 else 0 end) as procount17
					,	sum(case when datepart(HOUR,ManageDate) = 18 then 1 else 0 end) as procount18
					,	sum(case when datepart(HOUR,ManageDate) = 19 then 1 else 0 end) as procount19
					,	sum(case when datepart(HOUR,ManageDate) = 20 then 1 else 0 end) as procount20
					,	sum(case when datepart(HOUR,ManageDate) = 21 then 1 else 0 end) as procount21
					,	sum(case when datepart(HOUR,ManageDate) = 22 then 1 else 0 end) as procount22
					,	sum(case when datepart(HOUR,ManageDate) = 23 then 1 else 0 end) as procount23
					,	sum(case when datepart(HOUR,ManageDate) = 24 then 1 else 0 end) as procount24		
				from	eappprogress p
						inner join
						(
							select	id 
							from	eappdocument d
							where	(d.state  = 400 or d.state = -4) and d.progid is not null
							and		((depart <> '%' and departid = depart) or (depart = '%' and departid ILIKE '%'))
							and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
							and		regdate between sdate and edate				
						) d
						on p.DocumentID = d.id		
				where p.accesstype in (1,2,11)
				group by ManagerID
			)b 
			on a.WRITERID = b.managerid
		) a	
	) A
	ORDER BY DEPART,SORTNO;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
