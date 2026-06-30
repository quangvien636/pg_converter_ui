-- ─── FUNCTION: eappgetlastmanager ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetlastmanager(integer);
CREATE OR REPLACE FUNCTION public.eappgetlastmanager(
    progid integer
) RETURNS character varying
AS $function$
DECLARE
    manager character varying;
    docid integer;
    agreeorder integer;
BEGIN






	

	select AgreeOrder=AgreeOrder,State=State from public."eappdocument" where id=DocID

	
	if AgreeOrder = 100 and state=300 
	begin 
		SELECT Manager=EAPPProgress.ManagerID FROM public."EAPPProgress" WHERE EAPPProgress.DocumentID=DocID and ArriveState=200 and AccessType <> '10'
	end
	
	if Manager = ''
	begin 
		SELECT Manager=EAPPProgress.ManagerID FROM public."EAPPProgress" WHERE EAPPProgress.ID=eappgetlastmanager.progid
	end
	
	
	
	RETURN	(Manager);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
