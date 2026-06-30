-- ─── FUNCTION: bslg_spauthusercnt ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_spauthusercnt(character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthusercnt(
    orgcd character varying,
    grpcd character varying,
    useyn character varying,
    lang character varying,
    serach1 character varying,
    serach2 character varying
) RETURNS TABLE(
    orgcd text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		
	RETURN QUERY
	SELECT COUNT(*)
		
	FROM 
		CMONUsers 		A
	LEFT OUTER JOIN CMONCommCd	B	
	ON	A.PosFg1 = B.CommCd AND B.ClassCd = 'C001'
	WHERE
		 A.UseYn ILIKE UseYn
	AND 
	(	
		( OrgCd1 ILIKE OrgCd OR OrgCd2 ILIKE OrgCd OR OrgCd3 ILIKE OrgCd)
		OR 
		( OrgCd1 IN (SELECT OrgCd FROM  public."COMNGetOrganChild"(OrgCd)))
	)
	--AND public."CMONGetOrganGroup"(OrgCd1) = GrpCd
	AND A.UserNm1 ILIKE Serach1
	AND A.UserId ILIKE Serach2;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
