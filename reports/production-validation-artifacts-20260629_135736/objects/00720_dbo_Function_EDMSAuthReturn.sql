-- ─── FUNCTION: edmsauthreturn ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsauthreturn(integer);
CREATE OR REPLACE FUNCTION public.edmsauthreturn(
    docid integer
) RETURNS character varying
AS $function$
DECLARE
    returnvalue character varying;
BEGIN
 


	
	if ReturnValue is null
	begin
		select ReturnValue= 'Y' from EDMSAuthUser where Docid = edmsauthreturn.docid 
		
		if ReturnValue is null
		begin
			set ReturnValue = ''
		end
	end
	
	RETURN ReturnValue;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
