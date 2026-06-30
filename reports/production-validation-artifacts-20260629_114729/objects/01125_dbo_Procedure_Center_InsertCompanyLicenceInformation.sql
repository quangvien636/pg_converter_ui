-- ─── PROCEDURE→FUNCTION: center_insertcompanylicenceinformation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertcompanylicenceinformation(integer, character varying, character varying, character varying, character varying, character varying, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.center_insertcompanylicenceinformation(
    IN userno integer,
    IN licencekey character varying,
    IN name character varying,
    IN version character varying,
    IN db character varying,
    IN usercnt character varying,
    IN companylicenceinformationdate timestamp without time zone,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN

	
	INSERT INTO Center_CompanyLicenceInformation (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompanyLicenceInformationDate)
	VALUES (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompanyLicenceInformationDate);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
