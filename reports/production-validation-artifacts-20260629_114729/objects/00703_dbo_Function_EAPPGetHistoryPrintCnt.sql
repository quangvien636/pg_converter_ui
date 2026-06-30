-- ─── FUNCTION: eappgethistoryprintcnt ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgethistoryprintcnt(integer);
CREATE OR REPLACE FUNCTION public.eappgethistoryprintcnt(
    docid integer
) RETURNS integer
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    printcnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



		(select /* TOP 1 */ id from EAPPDocument where WGroup=(select WGroup from EAPPDocument where ID=eappgethistoryprintcnt.docid) order by id)
	and ActorID=Userid and HType=400 and ActState=300

	RETURN	(PrintCnt);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
