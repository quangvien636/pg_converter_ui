-- ─── FUNCTION: edmsdoc_saup ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsdoc_saup(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsdoc_saup(
    docid integer,
    saupname character varying
) RETURNS void
AS $function$
DECLARE
    chksaup character varying;
BEGIN


	
	if chkSaup = 1
	begin;
		update EDMS_Saupjang set SaupName = edmsdoc_saup.saupname,
		SaupCode = saupCode where DocID = edmsdoc_saup.docid
	end
	else
	begin
		if SaupName is not null and SaupCode is not null
		begin;
			insert into EDMS_Saupjang(DocID,SaupName,SaupCode) 
			values(DocID,SaupName,saupCode)
		end	
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
