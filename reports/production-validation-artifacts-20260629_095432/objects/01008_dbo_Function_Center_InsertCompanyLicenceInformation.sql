-- ─── FUNCTION: center_insertcompanylicenceinformation ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertcompanylicenceinformation(integer, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.center_insertcompanylicenceinformation(
    userno integer,
    licencekey character varying,
    name character varying,
    version character varying,
    db character varying,
    usercnt character varying,
    companylicenceinformationdate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN

	
	INSERT INTO Center_CompanyLicenceInformation (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompanyLicenceInformationDate)
	VALUES (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompanyLicenceInformationDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
