-- ─── FUNCTION: bslg_getdeptlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getdeptlog(character varying, character varying, character varying, character varying, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.bslg_getdeptlog(
    deptid character varying,
    sdate character varying,
    edate character varying,
    title character varying,
    content character varying,
    plot character varying,
    lang integer
) RETURNS TABLE(
    col1 text,
    col2 text,
    userid text,
    regdate text,
    content1 text,
    content2 text,
    att1 text,
    att2 text,
    att3 text,
    att4 text,
    att5 text,
    title text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	IF Lang = '1'
		Begin
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
		End
	Else IF Lang = '2'
		Begin
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
		End
	Else IF Lang = '3'
		Begin
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
		End
	Else
		Begin
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
