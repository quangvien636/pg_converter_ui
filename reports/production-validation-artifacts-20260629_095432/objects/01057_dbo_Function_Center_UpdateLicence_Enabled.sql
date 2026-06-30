-- ─── FUNCTION: center_updatelicence_enabled ───────────────────────────────
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
