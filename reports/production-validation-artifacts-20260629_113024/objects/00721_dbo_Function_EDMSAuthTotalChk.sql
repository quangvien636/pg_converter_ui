-- ─── FUNCTION: edmsauthtotalchk ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsauthtotalchk(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.edmsauthtotalchk(
    docid integer,
    eadocid integer,
    userid character varying
) RETURNS character varying
AS $function$
DECLARE
    returnvalue character varying;
BEGIN
 
	


	select ReturnValue='Y' from public."EDMSAuthDepart" where Docid = edmsauthtotalchk.docid and ORGCD = UserDepart
	
	if  ReturnValue = '' 
	begin 
		select ReturnValue='Y' from public."EDMSAuthUser" where Docid = edmsauthtotalchk.docid and UserID = edmsauthtotalchk.userid
	end

	if EADocid <> 0
	begin 
		select ReturnValue = 'Y' from EAPPDocument d inner join EAPPProgress p on d.ID=p.DocumentID where d.ID=edmsauthtotalchk.eadocid and (d.WriterID=edmsauthtotalchk.userid or p.ManagerID=edmsauthtotalchk.userid)
		
	end

	RETURN ReturnValue;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
