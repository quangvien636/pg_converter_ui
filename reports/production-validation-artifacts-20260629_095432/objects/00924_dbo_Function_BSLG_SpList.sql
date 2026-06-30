-- ─── FUNCTION: bslg_splist ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_splist(character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_splist(
    userid character varying,
    startdate character varying,
    enddate character varying,
    langindex character varying,
    title character varying,
    content character varying
) RETURNS TABLE(
    userid text,
    regdate text,
    content1 text,
    content2 text,
    att1 text,
    att2 text,
    att3 text,
    att4 text,
    att5 text,
    col10 text,
    usernm text,
    orgnm text,
    posnm text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	RETURN QUERY
	SELECT	bl.UserID, RegDate, Content1, Content2, att1, att2, att3, att4, att5, COALESCE(Title, '제목') Title
			, CASE LangIndex When '1' Then cu.UserNm1
							  When '2' Then cu.UserNm2
							  When '3' Then cu.UserNm3
			  ELSE cu.UserNm1
			  END As UserNm
			, public."CMONGetOrganNm"(cu.OrgCd1, LangIndex) As OrgNm
			, public."CMONGetCommCdNm"('C001', cu.PosFg1, LangIndex)  as PosNm
	FROM	CMONUsers cu, BSLG_Log bl
	WHERE	bl.UserID=bslg_splist.userid 
	AND     bl.UserID=cu.UserID
	AND		(RegDate >= bslg_splist.startdate AND RegDate <=  bslg_splist.enddate ) 
	AND		Title ILIKE '%' || Title || '%'
	AND		Content1 ILIKE '%' || Content || '%'
	ORDER BY RegDate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
