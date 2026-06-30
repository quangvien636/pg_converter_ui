-- ─── PROCEDURE→FUNCTION: center_insertmobiledevicesaccessrestrictions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_insertmobiledevicesaccessrestrictions(integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertmobiledevicesaccessrestrictions(
    IN userno integer,
    IN mobiletype character varying,
    IN osversion character varying,
    IN modulename character varying,
    IN deviceid character varying,
    IN devicename character varying
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Center_MobileDevicesAccessrestrictions(UserNo,mobileType,OSVersion,ModuleName,DeviceId,DeviceName,UUID,Enabled,RegDate) 
	values(UserNo,mobileType,OSVersion,ModuleName,DeviceId,DeviceName,UUID,0,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
