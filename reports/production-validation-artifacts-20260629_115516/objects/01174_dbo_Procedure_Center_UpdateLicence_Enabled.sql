-- ─── PROCEDURE→FUNCTION: center_updatelicence_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updatelicence_enabled();
CREATE OR REPLACE FUNCTION public.center_updatelicence_enabled(
) RETURNS void
AS $function$
BEGIN

	
	update Center_CompaniesLicence set Enabled = TRUE where LicenceKey = LicenceKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
