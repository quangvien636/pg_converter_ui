-- ─── PROCEDURE→FUNCTION: bslg_splist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_splist(character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_splist(
    IN userid character varying,
    IN startdate character varying,
    IN enddate character varying,
    IN langindex character varying,
    IN title character varying,
    IN content character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
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
