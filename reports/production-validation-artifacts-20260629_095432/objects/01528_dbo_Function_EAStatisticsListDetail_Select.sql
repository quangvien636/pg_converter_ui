-- ─── FUNCTION: eastatisticslistdetail_select ───────────────────────────────
DROP FUNCTION IF EXISTS public.eastatisticslistdetail_select();
CREATE OR REPLACE FUNCTION public.eastatisticslistdetail_select(
) RETURNS TABLE(
    id text,
    title text,
    departid text
)
AS $function$
BEGIN
IF WriterName = '부서계'
BEGIN
	RETURN QUERY
	SELECT	DEPART AS DEPARTNAME, writerid AS WRITERNAME, UserId AS WRITERID, DOCUMENTID AS ID, ARRIVEDATE, 
			MANAGEDATE, DEPARTID, DEPARTNAME1, PREMANAGESTATE, PREMANAGEDATE AS AUTOAFTERDATE, 
			TITLE
	FROM
		(
		SELECT	public."CMONGETORGANNM"(COALESCE(D.DEPARTID,ORGCD1),'1') AS DEPART,public."CMONGETUSERNM"(Userid,'1') AS writerid, A.Userid, B.DOCUMENTID, B.ARRIVEDATE, 
				B.MANAGEDATE, B.DEPARTID, B.DEPARTNAME1, B.PREMANAGESTATE, B.PREMANAGEDATE, 
				B.TITLE
		FROM 
			(
			SELECT	Userid , orgcd1
			FROM	CMonusers 
			WHERE	((depart <> '%' AND orgcd1 = depart) OR (depart = '%' AND orgcd1 ILIKE depart))
			) A
			LEFT JOIN
			(
				SELECT	DEPARTID,D.WRITERID , COUNT(1) AS DOCCOUNT	
				FROM	EAPPDOCUMENT D
				WHERE	(d.state  = 400 or d.state = -4) and d.progid is not null --종결된문서
				and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
				and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
				and		regdate between sdate and edate				
				GROUP BY D.WRITERID,DEPARTID
			) D
			ON A.USERID = D.WRITERID
			INNER JOIN
			(	--결재 합의 협조 수신 후결 보류 반려
				SELECT	P.DOCUMENTID, P.MANAGERID, P.ARRIVEDATE, P.MANAGEDATE, ED.DEPARTID, 
						P.DEPARTNAME1, P.MANAGESTATE, PS.PREMANAGESTATE, PS.PREMANAGEDATE, ED.TITLE 
				FROM	(
							SELECT	DOCUMENTID, MANAGERID, ARRIVEDATE, MANAGEDATE, DEPARTID, 
									DEPARTNAME1, MANAGESTATE, ID, ACCESSTYPE, LINEORDER
							FROM	EAPPPROGRESS 
						) P
						LEFT OUTER JOIN
						EAPPProgressSubData PS 
						on P.ID=PS.progid 
						OR (P.DocumentID=PS.PreDocumentID 
						AND P.ManagerID=PS.PreManagerID 
						AND P.AccessType=PS.PreAccessType 
						AND P.LineOrder=PS.PreLineOrder)				 
						INNER JOIN
						(
							SELECT	id, Title, DEPARTID
							FROM	eappdocument D
							WHERE	(D.state  = 400 OR D.state = -4) AND D.progid IS NOT NULL							
							AND		((formid <> 0 AND formid = formid) OR (formid = 0 AND formid ILIKE '%'))
							AND		regdate BETWEEN sdate AND edate				
						) ED
						on P.DocumentID = ED.id		
				WHERE	((depart <> '%' AND p.departid = depart) 
				OR (depart = '%' AND P.departid ILIKE depart))
				AND PS.PREMANAGESTATE = '620'				
			) B
		ON A.userid = B.MANAGERID
		AND B.PREMANAGESTATE = '620'
		) T
	WHERE DEPART = departName
END
ELSE IF WriterName = '전체계'
BEGIN
	RETURN QUERY
	SELECT	public."CMONGETORGANNM"(COALESCE(D.DEPARTID,ORGCD1),'1') AS DEPARTNAME,public."CMONGETUSERNM"(Userid,'1') AS WRITERNAME, A.Userid AS WRITERID, B.DOCUMENTID AS ID, B.ARRIVEDATE, 
			B.MANAGEDATE, B.DEPARTID, B.DEPARTNAME1, B.PREMANAGESTATE, B.PREMANAGEDATE AS AUTOAFTERDATE, 
			B.TITLE
	FROM 
		(
		SELECT	Userid , orgcd1
		FROM	CMonusers 
		WHERE	((depart <> '%' AND orgcd1 = depart) OR (depart = '%' AND orgcd1 ILIKE depart))
		) A
		LEFT JOIN
		(
			SELECT	DEPARTID,D.WRITERID , COUNT(1) AS DOCCOUNT	
			FROM	EAPPDOCUMENT D
			WHERE	(d.state  = 400 or d.state = -4) and d.progid is not null --종결된문서
			and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
			and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
			and		regdate between sdate and edate				
			GROUP BY D.WRITERID,DEPARTID
		) D
		ON A.USERID = D.WRITERID
		INNER JOIN
		(	--결재 합의 협조 수신 후결 보류 반려
			SELECT	P.DOCUMENTID, P.MANAGERID, P.ARRIVEDATE, P.MANAGEDATE, ED.DEPARTID, 
					P.DEPARTNAME1, P.MANAGESTATE, PS.PREMANAGESTATE, PS.PREMANAGEDATE, ED.TITLE 
			FROM	(
						SELECT	DOCUMENTID, MANAGERID, ARRIVEDATE, MANAGEDATE, DEPARTID, 
								DEPARTNAME1, MANAGESTATE, ID, ACCESSTYPE, LINEORDER
						FROM	EAPPPROGRESS 
					) P
					LEFT OUTER JOIN
					EAPPProgressSubData PS 
					on P.ID=PS.progid 
					OR (P.DocumentID=PS.PreDocumentID 
					AND P.ManagerID=PS.PreManagerID 
					AND P.AccessType=PS.PreAccessType 
					AND P.LineOrder=PS.PreLineOrder)				 
					INNER JOIN
					(
						SELECT	id, Title, DEPARTID
						FROM	eappdocument D
						WHERE	(D.state  = 400 OR D.state = -4) AND D.progid IS NOT NULL							
						AND		((formid <> 0 AND formid = formid) OR (formid = 0 AND formid ILIKE '%'))
						AND		regdate BETWEEN sdate AND edate				
					) ED
					on P.DocumentID = ED.id		
			WHERE	((depart <> '%' AND p.departid = depart) 
			OR (depart = '%' AND P.departid ILIKE depart))
			AND PS.PREMANAGESTATE = '620'				
		) B
	ON A.userid = B.MANAGERID
	AND B.PREMANAGESTATE = '620'
END
ELSE
BEGIN
	RETURN QUERY
	SELECT	DEPARTNAME, WRITERNAME, WRITERID, ID, ARRIVEDATE, 
			MANAGEDATE, DEPARTID, DEPARTNAME1, PREMANAGESTATE, AUTOAFTERDATE, 
			TITLE
	FROM	(
			SELECT	public."CMONGETORGANNM"(COALESCE(D.DEPARTID,ORGCD1),'1') AS DEPARTNAME,public."CMONGETUSERNM"(Userid,'1') AS WRITERNAME, A.Userid AS WRITERID, B.DOCUMENTID AS ID, B.ARRIVEDATE, 
			B.MANAGEDATE, B.DEPARTID, B.DEPARTNAME1, B.PREMANAGESTATE, B.PREMANAGEDATE AS AUTOAFTERDATE, 
			B.TITLE
			FROM 
				(
				SELECT	Userid , orgcd1
				FROM	CMonusers 
				WHERE	((depart <> '%' AND orgcd1 = depart) OR (depart = '%' AND orgcd1 ILIKE depart))
				AND UserId = WriterID
				) A
				LEFT JOIN
				(
					SELECT	DEPARTID,D.WRITERID , COUNT(1) AS DOCCOUNT	
					FROM	EAPPDOCUMENT D
					WHERE	(d.state  = 400 or d.state = -4) and d.progid is not null --종결된문서
					and		((depart <> '%' and d.departid = depart) or (depart = '%' and d.departid ILIKE depart))
					and		((formid <> 0 and formid = formid) or (formid = 0 and formid ILIKE '%'))
					and		regdate between sdate and edate				
					GROUP BY D.WRITERID,DEPARTID
				) D
				ON A.USERID = D.WRITERID
				INNER JOIN
				(	--결재 합의 협조 수신 후결 보류 반려
					SELECT	P.DOCUMENTID, P.MANAGERID, P.ARRIVEDATE, P.MANAGEDATE, P.DEPARTID, 
							P.DEPARTNAME1, P.MANAGESTATE, PS.PREMANAGESTATE, PS.PREMANAGEDATE, ED.TITLE 
					FROM	(
								SELECT	DOCUMENTID, MANAGERID, ARRIVEDATE, MANAGEDATE, DEPARTID, 
										DEPARTNAME1, MANAGESTATE, ID, ACCESSTYPE, LINEORDER
								FROM	EAPPPROGRESS 
							) P
							LEFT OUTER JOIN
							EAPPProgressSubData PS 
							on P.ID=PS.progid 
							OR (P.DocumentID=PS.PreDocumentID 
							AND P.ManagerID=PS.PreManagerID 
							AND P.AccessType=PS.PreAccessType 
							AND P.LineOrder=PS.PreLineOrder)				 
							INNER JOIN
							(
								SELECT	id, Title, DEPARTID
								FROM	eappdocument D
								WHERE	(D.state  = 400 OR D.state = -4) AND D.progid IS NOT NULL							
								AND		((formid <> 0 AND formid = formid) OR (formid = 0 AND formid ILIKE '%'))
								AND		regdate BETWEEN sdate AND edate				
							) ED
							on P.DocumentID = ED.id		
					WHERE	((depart <> '%' AND p.departid = depart) 
					OR (depart = '%' AND P.departid ILIKE depart))
					AND PS.PREMANAGESTATE = '620'				
				) B
			ON A.userid = B.MANAGERID
			AND B.PREMANAGESTATE = '620'
			) T
	WHERE T.DEPARTNAME = departName;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
