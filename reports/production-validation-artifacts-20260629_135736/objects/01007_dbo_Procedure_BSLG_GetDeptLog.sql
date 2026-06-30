-- ─── PROCEDURE→FUNCTION: bslg_getdeptlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getdeptlog(character varying, character varying, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.bslg_getdeptlog(
    IN deptid character varying,
    IN sdate character varying,
    IN edate character varying,
    IN title character varying,
    IN content character varying,
    IN plot character varying,
    IN lang integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	IF Lang = '1' THEN
			RETURN QUERY
			SELECT	B.UserNm1 usernm,D.CommCdNm commcd,A.UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM	BSLG_Log A
			inner join CMONUsers B
			on A.UserID = B.UserId
			inner join CMONOrgan C
			on B.OrgCd1 = C.OrgCd
			inner join CMONCommCd D
			on B.PosFg1 = D.commcd
			where
			(RegDate >= bslg_getdeptlog.sdate AND RegDate <=  bslg_getdeptlog.edate )
			AND     Title ILIKE '%' || Title || '%'
			AND     Content1 ILIKE '%' || Content || '%'
			AND		Plot is null 
			AND		B.UseYn = 'Y'
			AND		C.OrgCd = bslg_getdeptlog.deptid
			AND		D.ClassCd = 'C001'
			order by D.CommCd,A.UserID,A.RegDate
		END IF;
	ELSIF Lang = '2' THEN
			RETURN QUERY
			SELECT	B.UserNm2 usernm,D.Etc1Cd commcd,A.UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM	BSLG_Log A
			inner join CMONUsers B
			on A.UserID = B.UserId
			inner join CMONOrgan C
			on B.OrgCd1 = C.OrgCd
			inner join CMONCommCd D
			on B.PosFg1 = D.commcd
			where
			(RegDate >= bslg_getdeptlog.sdate AND RegDate <=  bslg_getdeptlog.edate )
			AND     Title ILIKE '%' || Title || '%'
			AND     Content1 ILIKE '%' || Content || '%'
			AND		Plot is null 
			AND		B.UseYn = 'Y'
			AND		C.OrgCd = bslg_getdeptlog.deptid
			AND		D.ClassCd = 'C001'
			order by D.CommCd,A.UserID,A.RegDate
		END IF;
	ELSIF Lang = '3' THEN
			RETURN QUERY
			SELECT	B.UserNm3 usernm,D.Etc2Cd commcd,A.UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM	BSLG_Log A
			inner join CMONUsers B
			on A.UserID = B.UserId
			inner join CMONOrgan C
			on B.OrgCd1 = C.OrgCd
			inner join CMONCommCd D
			on B.PosFg1 = D.commcd
			where
			(RegDate >= bslg_getdeptlog.sdate AND RegDate <=  bslg_getdeptlog.edate )
			AND     Title ILIKE '%' || Title || '%'
			AND     Content1 ILIKE '%' || Content || '%'
			AND		Plot is null 
			AND		B.UseYn = 'Y'
			AND		C.OrgCd = bslg_getdeptlog.deptid
			AND		D.ClassCd = 'C001'
			order by D.CommCd,A.UserID,A.RegDate
		END IF;
	ELSE
			RETURN QUERY
			SELECT	B.UserNm4 usernm,D.Etc3Cd commcd,A.UserID,RegDate,Content1, Content2, att1, att2, att3, att4, att5, Title
			FROM	BSLG_Log A
			inner join CMONUsers B
			on A.UserID = B.UserId
			inner join CMONOrgan C
			on B.OrgCd1 = C.OrgCd
			inner join CMONCommCd D
			on B.PosFg1 = D.commcd
			where
			(RegDate >= bslg_getdeptlog.sdate AND RegDate <=  bslg_getdeptlog.edate )
			AND     Title ILIKE '%' || Title || '%'
			AND     Content1 ILIKE '%' || Content || '%'
			AND		Plot is null 
			AND		B.UseYn = 'Y'
			AND		C.OrgCd = bslg_getdeptlog.deptid
			AND		D.ClassCd = 'C001'
			order by D.CommCd,A.UserID,A.RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
