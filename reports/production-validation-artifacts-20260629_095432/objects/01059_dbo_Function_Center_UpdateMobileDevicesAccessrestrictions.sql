-- ─── FUNCTION: center_updatemobiledevicesaccessrestrictions ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updatemobiledevicesaccessrestrictions(bigint, boolean);
CREATE OR REPLACE FUNCTION public.center_updatemobiledevicesaccessrestrictions(
    deviceno bigint,
    enabled boolean
) RETURNS void
AS $function$
BEGIN


	update Center_MobileDevicesAccessrestrictions set Enabled = center_updatemobiledevicesaccessrestrictions.enabled WHERE DeviceNo = center_updatemobiledevicesaccessrestrictions.deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
