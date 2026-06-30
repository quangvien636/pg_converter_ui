-- ─── FUNCTION: center_insertlicence ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertlicence(integer, character varying, character varying, character varying, character varying, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.center_insertlicence(
    userno integer,
    licencekey character varying,
    name character varying,
    version character varying,
    db character varying,
    usercnt integer,
    companieslicencedate timestamp without time zone,
    enabled boolean
) RETURNS void
AS $function$
BEGIN

	
	INSERT INTO Center_CompaniesLicence (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompaniesLicenceDate,Enabled)
	VALUES (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompaniesLicenceDate,Enabled);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
