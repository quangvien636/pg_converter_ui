-- ─── FUNCTION: bslg_getread ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getread(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getread(
    regid character varying,
    regdate character varying,
    lang character varying
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
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
