-- ─── FUNCTION: eappauthchk ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappauthchk(integer);
CREATE OR REPLACE FUNCTION public.eappauthchk(
    docid integer
) RETURNS character varying
AS $function$
DECLARE
    returnvalue character varying;
BEGIN
 


	begin 
		if exists (select d.id from EAPPDocument d inner join EAPPProgress p on d.ID=p.DocumentID
		where d.ID=eappauthchk.docid and (d.WriterID=UserID or p.ManagerID=UserID))
		begin 
			set ReturnValue = 'Y'
		end
		else
		begin
			set ReturnValue = ''
		end
	end
	else
	begin 
		set ReturnValue = ''
	end
	RETURN ReturnValue;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
