-- ─── FUNCTION: center_insertmobiledevicesaccessrestrictions ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertmobiledevicesaccessrestrictions(integer, character varying, character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertmobiledevicesaccessrestrictions(
    userno integer,
    mobiletype character varying,
    osversion character varying,
    modulename character varying,
    deviceid character varying,
    devicename character varying
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Center_MobileDevicesAccessrestrictions(UserNo,mobileType,OSVersion,ModuleName,DeviceId,DeviceName,UUID,Enabled,RegDate) 
	values(UserNo,mobileType,OSVersion,ModuleName,DeviceId,DeviceName,UUID,0,NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
