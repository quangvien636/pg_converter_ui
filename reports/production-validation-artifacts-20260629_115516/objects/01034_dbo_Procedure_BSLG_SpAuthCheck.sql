-- ─── PROCEDURE→FUNCTION: bslg_spauthcheck ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_spauthcheck(character varying);
CREATE OR REPLACE FUNCTION public.bslg_spauthcheck(
    IN userid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT count(*) as Permissioncount From BSLG_SpAuthInfo Where UserID=bslg_spauthcheck.userid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
