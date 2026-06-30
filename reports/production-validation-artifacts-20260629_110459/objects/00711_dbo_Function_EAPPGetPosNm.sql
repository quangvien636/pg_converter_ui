-- ─── FUNCTION: eappgetposnm ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetposnm(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappgetposnm(
    posid character varying,
    posnm1 character varying,
    posnm2 character varying,
    posnm3 character varying,
    posnm4 character varying
) RETURNS character varying
AS $function$
DECLARE
    rposnm character varying;
BEGIN



	 BEGIN	
		set rPosNm = eappgetposnm.posnm1
	 END
	ELSE IF Lang = '2'
	 BEGIN
		set rPosNm = eappgetposnm.posnm2
	 END
	ELSE IF Lang = '3'
	 BEGIN
		set rPosNm = eappgetposnm.posnm3
	 END
	ELSE IF Lang = '4'
	 BEGIN
		set rPosNm = eappgetposnm.posnm4
	 END
	ELSE
	 BEGIN
		set rPosNm = eappgetposnm.posnm1
	 END
	
	if rPosNm = '' or rPosNm is null
	begin
		select rPosNm=public."CMONGetPosNm"(PosId,Lang)
	end
	
	RETURN	(rPosNm);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
