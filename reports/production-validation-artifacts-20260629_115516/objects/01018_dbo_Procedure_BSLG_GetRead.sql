-- ─── PROCEDURE→FUNCTION: bslg_getread ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getread(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getread(
    IN regid character varying,
    IN regdate character varying,
    IN lang character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	RETURN QUERY
	SELECT 
		(SELECT CASE Lang WHEN '1' THEN cu.UserNm1
							 WHEN '2' THEN cu.UserNm2
							 WHEN '3' THEN cu.UserNm3 
							 WHEN '4' THEN cu.UserNm4
				  ELSE UserNm1 
				  END as UserNm
			FROM CMONUsers cu WHERE cu.UserID = ReaderId ) as ReadNm
		, (SELECT public."CMONGetCommCdNm"('C001', cu.PosFg1, Lang) FROM CMONUsers cu WHERE cu.UserID = ReaderId) as PosNm
		, (SELECT public."CMONGetOrganNm"(cu.OrgCd1, Lang)  FROM CMONUsers cu WHERE cu.UserID = ReaderId) as OrgNm
		, ReadDate
	FROM BSLG_Reader
	WHERE RegId = bslg_getread.regid
	AND   RegDate = bslg_getread.regdate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
