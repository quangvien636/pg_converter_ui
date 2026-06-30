-- ─── PROCEDURE→FUNCTION: eastatisticsregtype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.eastatisticsregtype();
CREATE OR REPLACE FUNCTION public.eastatisticsregtype(
) RETURNS SETOF record
AS $function$
DECLARE
    formid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*
	결재 유형별 현황
	Sort :	부서 / 오름차순
	검색 :	기간(기안일 from : to)
			부서
			양식
formid = 0 이면 전체
depart = '%' 이면 전체


	,		depart	varchar(255)	--부서코드
	,		sdate	varchar(10) --시작일
	,		edate	varchar(10) --종료일

	formid := (0		--약식지 아이디);
	,		depart	= '0011'
	,		sdate	= '1960-01-01'--시작일
	,		edate	= '2009-03-01'--종료일
--*/	

	SELECT	DEPART,WRITERID,USERID,DOCCOUNT,APP,HAB,HYEB,SU,HOO,AUTOHOO,BO,BAN,SUM,SORTNO
	FROM 
	(
		SELECT public."CMONGETORGANNM"(COALESCE(A.DEPARTID,ORGCD1),'1') AS DEPART,public."CMONGETUSERNM"(Userid,'1') as writerid,UserId,COALESCE(DOCCOUNT,0) as DOCCOUNT,COALESCE(APP,0) as APP ,COALESCE(HAB,0) as HAB ,COALESCE(HYEB,0) as HYEB ,COALESCE(SU,0) as SU ,COALESCE(HOO,0) as  HOO,COALESCE(AUTOHOO,0) as  AUTOHOO,COALESCE(BO,0) as  BO,COALESCE(BAN,0) as  BAN,COALESCE(DOCCOUNT,0)+COALESCE(APP,0)+COALESCE(HAB,0)+COALESCE(HYEB,0)+COALESCE(SU,0)+COALESCE(HOO,0)+COALESCE(AUTOHOO,0)+COALESCE(BO,0)+COALESCE(BAN,0) as sum,1 AS SORTNO		
		FROM 
			(
			select Userid , orgcd1
			from CMonusers c
			where	((depart <> '%' and orgcd1 = depart) or (depart = '%' and orgcd1 ILIKE depart))
			) c
			left join
			( --유저별 기안건수
				SELECT	DEPARTID,D.WRITERID , COUNT(1) AS DOCCOUNT	
				FROM	EAPPDOCUMENT D
				where	(d.state  = 400 or d.state = -4) and d.progid is not null --종결된문서
				and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
				and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
				and		regdate between sdate and edate				
				GROUP BY D.WRITERID,DEPARTID
			) A
			on c.userid = a.writerid
			left JOIN
			(	--결재 합의 협조 수신 후결 보류 반려
				SELECT	MANAGERID
				,		SUM(CASE	WHEN ACCESSTYPE = 1  THEN 1
								ELSE 0
						END	)	AS APP --결재
				,		SUM(CASE	WHEN ACCESSTYPE = 2  THEN 1
								ELSE 0
						END	)	AS HAB --합의
				,		SUM(CASE	WHEN ACCESSTYPE = 10  THEN 1
								ELSE 0
						END	)	AS HYEB --협조
				,		SUM(CASE	WHEN ACCESSTYPE = 20  THEN 1
								ELSE 0
						END	)	AS SU --수신
				,		SUM(CASE	WHEN MANAGESTATE = 600  THEN 1
								ELSE 0
						END	)	AS HOO --후결
				,		SUM(CASE	WHEN PreMANAGESTATE = 620  THEN 1
										ELSE 0
								END	)	AS AUTOHOO --자동후결
				,		SUM(CASE	WHEN MANAGESTATE = 500  THEN 1
								ELSE 0
						END	)	AS BO --보류
				,		SUM(CASE	WHEN MANAGESTATE = 300  THEN 1
								ELSE 0
						END	)	AS BAN --반려
				FROM	EAPPPROGRESS p
						left outer join EAPPProgressSubData ps on p.ID=ps.progid or (p.DocumentID=ps.PreDocumentID and p.ManagerID=ps.PreManagerID and p.AccessType=ps.PreAccessType and p.LineOrder=ps.PreLineOrder)				 
						inner join
						(
							select	id 
							from	eappdocument d
							where	(d.state  = 400 or d.state = -4)  and d.progid is not null							
							and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
							and		regdate between sdate and edate				
						) d
						on p.DocumentID = d.id		
				where	((depart <> '%' and p.departid = depart) or (depart = '%' and p.departid ILIKE depart))
				GROUP BY MANAGERID
			)B
			ON c.userid = B.MANAGERID	

		UNION ALL
	
		SELECT  DEPART,'부서계','' AS UserId,SUM(DOCCOUNT),SUM(APP),SUM(HAB),SUM(HYEB),SUM(SU),SUM(HOO),SUM(AUTOHOO),SUM(BO),SUM(BAN),SUM(DOCCOUNT)+SUM(APP)+SUM(HAB)+SUM(HYEB)+SUM(SU)+SUM(HOO)+SUM(AUTOHOO)+SUM(BO)+SUM(BAN) as sum,2 AS SORTNO
		FROM	(
				SELECT public."CMONGETORGANNM"(COALESCE(A.DEPARTID,ORGCD1),'1') AS DEPART,public."CMONGETUSERNM"(Userid,'1') as writerid,COALESCE(DOCCOUNT,0) as DOCCOUNT,COALESCE(APP,0) as APP ,COALESCE(HAB,0) as HAB ,COALESCE(HYEB,0) as HYEB ,COALESCE(SU,0) as SU ,COALESCE(HOO,0) as  HOO,COALESCE(AUTOHOO,0) as  AUTOHOO,COALESCE(BO,0) as  BO,COALESCE(BAN,0) as  BAN,COALESCE(DOCCOUNT,0)+COALESCE(APP,0)+COALESCE(HAB,0)+COALESCE(HYEB,0)+COALESCE(SU,0)+COALESCE(HOO,0)+COALESCE(AUTOHOO,0)+COALESCE(BO,0)+COALESCE(BAN,0) as sum,1 AS SORTNO		
				FROM 
					(
					select Userid,orgcd1 
					from CMonusers c
					where	((depart <> '%' and orgcd1 = depart) or (depart = '%' and orgcd1 ILIKE depart))
					) c
					left join
					( --유저별 기안건수
						SELECT	DEPARTID,D.WRITERID , COUNT(1) AS DOCCOUNT	
						FROM	EAPPDOCUMENT D
						where	(d.state  = 400 or d.state = -4) and d.progid is not null --종결된문서
						and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
						and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
						and		regdate between sdate and edate				
						GROUP BY D.WRITERID,DEPARTID
					) A
					on c.userid = a.writerid
					left JOIN
					(	--결재 합의 협조 수신 후결 보류 반려
						SELECT	MANAGERID
						,		SUM(CASE	WHEN ACCESSTYPE = 1  THEN 1
										ELSE 0
								END	)	AS APP --결재
						,		SUM(CASE	WHEN ACCESSTYPE = 2  THEN 1
										ELSE 0
								END	)	AS HAB --합의
						,		SUM(CASE	WHEN ACCESSTYPE = 10  THEN 1
										ELSE 0
								END	)	AS HYEB --협조
						,		SUM(CASE	WHEN ACCESSTYPE = 20  THEN 1
										ELSE 0
								END	)	AS SU --수신
						,		SUM(CASE	WHEN MANAGESTATE = 600  THEN 1
										ELSE 0
								END	)	AS HOO --후결
						,		SUM(CASE	WHEN PreMANAGESTATE = 620  THEN 1
										ELSE 0
								END	)	AS AUTOHOO --자동후결
						,		SUM(CASE	WHEN MANAGESTATE = 500  THEN 1
										ELSE 0
								END	)	AS BO --보류
						,		SUM(CASE	WHEN MANAGESTATE = 300  THEN 1
										ELSE 0
								END	)	AS BAN --반려
						FROM	EAPPPROGRESS p	
								left outer join EAPPProgressSubData ps on p.ID=ps.progid or (p.DocumentID=ps.PreDocumentID and p.ManagerID=ps.PreManagerID and p.AccessType=ps.PreAccessType and p.LineOrder=ps.PreLineOrder)		 
								inner join
								(
									select	id 
									from	eappdocument d
									where	(d.state  = 400 or d.state = -4)  and d.progid is not null							
									and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
									and		regdate between sdate and edate				
								) d
								on p.DocumentID = d.id		
						where	((depart <> '%' and p.departid = depart) or (depart = '%' and p.departid ILIKE depart))
						GROUP BY MANAGERID
					)B
					ON c.userid = B.MANAGERID	
				) A					
			GROUP BY DEPART	

		union all

		SELECT  'Z','전체계','' AS UserId,SUM(DOCCOUNT),SUM(APP),SUM(HAB),SUM(HYEB),SUM(SU),SUM(HOO),SUM(AUTOHOO),SUM(BO),SUM(BAN),SUM(DOCCOUNT)+SUM(APP)+SUM(HAB)+SUM(HYEB)+SUM(SU)+SUM(HOO)+SUM(AUTOHOO)+SUM(BO)+SUM(BAN) as sum,3 AS SORTNO
		FROM	(
				SELECT public."CMONGETORGANNM"(COALESCE(A.DEPARTID,ORGCD1),'1') AS DEPART,public."CMONGETUSERNM"(Userid,'1') as writerid,COALESCE(DOCCOUNT,0) as DOCCOUNT,COALESCE(APP,0) as APP ,COALESCE(HAB,0) as HAB ,COALESCE(HYEB,0) as HYEB ,COALESCE(SU,0) as SU ,COALESCE(HOO,0) as  HOO,COALESCE(AUTOHOO,0) as  AUTOHOO,COALESCE(BO,0) as  BO,COALESCE(BAN,0) as  BAN,COALESCE(DOCCOUNT,0)+COALESCE(APP,0)+COALESCE(HAB,0)+COALESCE(HYEB,0)+COALESCE(SU,0)+COALESCE(HOO,0)+COALESCE(AUTOHOO,0)+COALESCE(BO,0)+COALESCE(BAN,0) as sum,1 AS SORTNO		
				FROM 
					(
					select Userid , orgcd1
					from CMonusers c
					where	((depart <> '%' and orgcd1 = depart) or (depart = '%' and orgcd1 ILIKE depart))
					) c
					left join
					( --유저별 기안건수
						SELECT	DEPARTID,D.WRITERID , COUNT(1) AS DOCCOUNT	
						FROM	EAPPDOCUMENT D
						where	(d.state  = 400 or d.state = -4) and d.Progid is not null --종결된문서
						and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
						and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
						and		regdate between sdate and edate				
						GROUP BY D.WRITERID,DEPARTID
					) A
					on c.userid = a.writerid
					left JOIN
					(	--결재 합의 협조 수신 후결 보류 반려
						SELECT	MANAGERID
						,		SUM(CASE	WHEN ACCESSTYPE = 1  THEN 1
										ELSE 0
								END	)	AS APP --결재
						,		SUM(CASE	WHEN ACCESSTYPE = 2  THEN 1
										ELSE 0
								END	)	AS HAB --합의
						,		SUM(CASE	WHEN ACCESSTYPE = 10  THEN 1
										ELSE 0
								END	)	AS HYEB --협조
						,		SUM(CASE	WHEN ACCESSTYPE = 20  THEN 1
										ELSE 0
								END	)	AS SU --수신
						,		SUM(CASE	WHEN MANAGESTATE = 600  THEN 1
										ELSE 0
								END	)	AS HOO --후결
						,		SUM(CASE	WHEN PreMANAGESTATE = 620  THEN 1
										ELSE 0
								END	)	AS AUTOHOO --자동후결
						,		SUM(CASE	WHEN MANAGESTATE = 500  THEN 1
										ELSE 0
								END	)	AS BO --보류
						,		SUM(CASE	WHEN MANAGESTATE = 300  THEN 1
										ELSE 0
								END	)	AS BAN --반려
						FROM	EAPPPROGRESS p			 
								left outer join EAPPProgressSubData ps on p.ID=ps.progid or (p.DocumentID=ps.PreDocumentID and p.ManagerID=ps.PreManagerID and p.AccessType=ps.PreAccessType and p.LineOrder=ps.PreLineOrder)
								inner join
								(
									select	id 
									from	eappdocument d
									where	(d.state  = 400 or d.state = -4) and d.progid is not null 							
									and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
									and		regdate between sdate and edate				
								) d
								on p.DocumentID = d.id		
						where	((depart <> '%' and p.departid = depart) or (depart = '%' and p.departid ILIKE depart))
						GROUP BY MANAGERID
					)B
					ON c.userid = B.MANAGERID	
				) A		
	) A			
	ORDER BY DEPART,SORTNO;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
