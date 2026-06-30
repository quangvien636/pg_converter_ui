-- ─── FUNCTION: center_getlicence ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getlicence();
CREATE OR REPLACE FUNCTION public.center_getlicence(
) RETURNS TABLE(
    companieslicenceno bigserial,
    userno integer,
    licencekey character varying(50),
    name character varying(50),
    version character varying(50),
    db character varying(50),
    usercnt integer,
    companieslicencedate timestamp without time zone,
    enabled boolean
)
AS $function$
BEGIN

	
	RETURN QUERY
	select * from Center_CompaniesLicence where LicenceKey = LicenceKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
