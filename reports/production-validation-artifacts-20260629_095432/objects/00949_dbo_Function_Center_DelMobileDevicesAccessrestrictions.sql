-- ─── FUNCTION: center_delmobiledevicesaccessrestrictions ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_delmobiledevicesaccessrestrictions(bigint);
CREATE OR REPLACE FUNCTION public.center_delmobiledevicesaccessrestrictions(
    deviceno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_MobileDevicesAccessrestrictions WHERE DeviceNo = center_delmobiledevicesaccessrestrictions.deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
