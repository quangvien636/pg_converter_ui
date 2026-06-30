-- ─── PROCEDURE→FUNCTION: center_insertlicence ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertlicence(integer, character varying, character varying, character varying, character varying, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.center_insertlicence(
    IN userno integer,
    IN licencekey character varying,
    IN name character varying,
    IN version character varying,
    IN db character varying,
    IN usercnt integer,
    IN companieslicencedate timestamp without time zone,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN

	
	INSERT INTO Center_CompaniesLicence (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompaniesLicenceDate,Enabled)
	VALUES (UserNo,LicenceKey,Name,Version,DB,UserCnt,CompaniesLicenceDate,Enabled);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
