-- ─── PROCEDURE→FUNCTION: eappcancelmanage ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.eappcancelmanage(integer);
CREATE OR REPLACE FUNCTION public.eappcancelmanage(
    IN docid integer
) RETURNS void
AS $function$
DECLARE
    actorid character varying;
BEGIN


	IF actorid = UserID THEN;
		UPDATE EAPPDocument SET HistoryID = null WHERE ID=eappcancelmanage.docid ;
		UPDATE EAPPDocument SET HistoryID = null WHERE WGroup in (select wgroup from eappdocument where id=eappcancelmanage.docid )
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
