-- ─── PROCEDURE→FUNCTION: center_getmobiledevicesaccessrestrictions_modulename ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getmobiledevicesaccessrestrictions_modulename(character varying);
CREATE OR REPLACE FUNCTION public.center_getmobiledevicesaccessrestrictions_modulename(
    IN uuid character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select * from Center_MobileDevicesAccessrestrictions WHERE UUID = center_getmobiledevicesaccessrestrictions_modulename.uuid and ModuleName = moduleName;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
