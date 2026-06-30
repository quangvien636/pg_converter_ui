-- ─── FUNCTION: eappgetgrdnm ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetgrdnm(character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.eappgetgrdnm(
    grdid character varying,
    grdnm1 character varying,
    grdnm2 character varying,
    grdnm3 character varying,
    grdnm4 character varying
) RETURNS character varying
AS $function$
DECLARE
    rgrdnm character varying;
BEGIN



	 BEGIN	
		set rGrdNm = eappgetgrdnm.grdnm1
	 END
	ELSE IF Lang = '2'
	 BEGIN
		set rGrdNm = eappgetgrdnm.grdnm2
	 END
	ELSE IF Lang = '3'
	 BEGIN
		set rGrdNm = eappgetgrdnm.grdnm3
	 END
	ELSE IF Lang = '4'
	 BEGIN
		set rGrdNm = eappgetgrdnm.grdnm4
	 END
	ELSE
	 BEGIN
		set rGrdNm = eappgetgrdnm.grdnm1
	 END
	
	if rGrdNm = '' or rGrdNm is null
	begin
		select rGrdNm=public."CMONGetGrdNm"(GrdId,Lang)
	end
	
	RETURN	(rGrdNm);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
