-- ─── PROCEDURE→FUNCTION: bslg_orglogyyyydel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_orglogyyyydel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_orglogyyyydel(
    IN departid character varying,
    IN date character varying
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_OrgLogYYYY WHERE RegDate=bslg_orglogyyyydel.date AND DepartID=bslg_orglogyyyydel.departid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
