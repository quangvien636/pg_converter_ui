-- ─── PROCEDURE→FUNCTION: bslg_spauthusercnt ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_spauthusercnt(character varying, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthusercnt(
    IN orgcd character varying,
    IN grpcd character varying,
    IN useyn character varying,
    IN lang character varying,
    IN serach1 character varying,
    IN serach2 character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
		
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
