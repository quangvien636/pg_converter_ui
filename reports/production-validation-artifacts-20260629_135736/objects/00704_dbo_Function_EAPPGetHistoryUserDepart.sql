-- ─── FUNCTION: eappgethistoryuserdepart ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgethistoryuserdepart(integer);
CREATE OR REPLACE FUNCTION public.eappgethistoryuserdepart(
    docid integer
) RETURNS character varying
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    departid character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	(select Departid=DepartID From eappprogress where documentid =
		(select /* TOP 1 */ id from eappdocument where wgroup = 
			(select wgroup from eappdocument where id=eappgethistoryuserdepart.docid) 
		order by ID desc)
	and ManagerID=Userid)


	RETURN	(Departid);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
