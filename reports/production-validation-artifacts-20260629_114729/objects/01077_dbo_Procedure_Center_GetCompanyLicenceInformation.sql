-- ─── PROCEDURE→FUNCTION: center_getcompanylicenceinformation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getcompanylicenceinformation();
CREATE OR REPLACE FUNCTION public.center_getcompanylicenceinformation(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	select * from Center_CompanyLicenceInformation
	order by CompanyLicenceInformationNo desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
