-- ─── FUNCTION: eappgetorgannm ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetorgannm(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappgetorgannm(
    orgid character varying,
    orgnm1 character varying,
    orgnm2 character varying,
    orgnm3 character varying,
    orgnm4 character varying
) RETURNS character varying
AS $function$
DECLARE
    rorgnm character varying;
BEGIN



	 BEGIN	
		set rOrgNm = eappgetorgannm.orgnm1
	 END
	ELSE IF Lang = '2'
	 BEGIN
		set rOrgNm = eappgetorgannm.orgnm2
	 END
	ELSE IF Lang = '3'
	 BEGIN
		set rOrgNm = eappgetorgannm.orgnm3
	 END
	ELSE IF Lang = '4'
	 BEGIN
		set rOrgNm = eappgetorgannm.orgnm4
	 END
	ELSE
	 BEGIN
		set rOrgNm = eappgetorgannm.orgnm1
	 END
	
	if rOrgNm = '' or rOrgNm is null
	begin
		select rOrgNm=public."CMONGetOrganNm"(OrgId,Lang)
	end
	
	RETURN	(rOrgNm);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
