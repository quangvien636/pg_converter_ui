-- ─── FUNCTION: eappcancelmanage ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappcancelmanage(integer);
CREATE OR REPLACE FUNCTION public.eappcancelmanage(
    docid integer
) RETURNS void
AS $function$
DECLARE
    actorid character varying;
BEGIN


	if actorid = UserID 
	begin ;
		UPDATE EAPPDocument SET HistoryID = null WHERE ID=eappcancelmanage.docid ;
		UPDATE EAPPDocument SET HistoryID = null WHERE WGroup in (select wgroup from eappdocument where id=eappcancelmanage.docid )
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
