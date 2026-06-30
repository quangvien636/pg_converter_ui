-- ─── FUNCTION: eappgetlastmanagedate ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetlastmanagedate(integer);
CREATE OR REPLACE FUNCTION public.eappgetlastmanagedate(
    progid integer
) RETURNS timestamp without time zone
AS $function$
DECLARE
    managedate timestamp without time zone;
BEGIN




	
	SELECT ManageDate=EAPPProgress.ManageDate FROM public."EAPPProgress" WHERE EAPPProgress.ID=eappgetlastmanagedate.progid


	RETURN	(ManageDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
