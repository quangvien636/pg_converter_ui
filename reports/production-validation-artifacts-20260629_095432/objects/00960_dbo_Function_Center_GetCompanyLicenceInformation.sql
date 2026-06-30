-- ─── FUNCTION: center_getcompanylicenceinformation ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getcompanylicenceinformation();
CREATE OR REPLACE FUNCTION public.center_getcompanylicenceinformation(
) RETURNS TABLE(
    companylicenceinformationno bigserial,
    userno integer,
    licencekey character varying(50),
    name character varying(50),
    version character varying(50),
    db character varying(50),
    usercnt character varying(50),
    companylicenceinformationdate timestamp without time zone
)
AS $function$
BEGIN

	
	RETURN QUERY
	select * from Center_CompanyLicenceInformation
	order by CompanyLicenceInformationNo desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
