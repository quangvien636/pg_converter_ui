-- ─── FUNCTION: edmsauthchk ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsauthchk(integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsauthchk(
    docid integer,
    userid character varying
) RETURNS character varying
AS $function$
DECLARE
    returnvalue character varying;
BEGIN
 	

	
	if ReturnValue is null
	begin
		select ReturnValue= 'Y' from EDMSAuthUser where Docid = edmsauthchk.docid and UserID = edmsauthchk.userid
		
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
