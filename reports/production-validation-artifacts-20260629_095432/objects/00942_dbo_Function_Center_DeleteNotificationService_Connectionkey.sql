-- ─── FUNCTION: center_deletenotificationservice_connectionkey ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deletenotificationservice_connectionkey(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.center_deletenotificationservice_connectionkey(
    companyno integer,
    projectcode character varying,
    connectionkey integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_NotificationService 
	where CompanyNo = center_deletenotificationservice_connectionkey.companyno
	and ProjectCode = center_deletenotificationservice_connectionkey.projectcode
	and Connectionkey = center_deletenotificationservice_connectionkey.connectionkey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
