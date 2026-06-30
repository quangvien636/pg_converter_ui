-- ─── PROCEDURE→FUNCTION: center_deletenotificationservice_connectionkey ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deletenotificationservice_connectionkey(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.center_deletenotificationservice_connectionkey(
    IN companyno integer,
    IN projectcode character varying,
    IN connectionkey integer
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
