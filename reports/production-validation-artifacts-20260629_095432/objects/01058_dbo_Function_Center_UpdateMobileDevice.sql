-- ─── FUNCTION: center_updatemobiledevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updatemobiledevice(bigint, boolean);
CREATE OR REPLACE FUNCTION public.center_updatemobiledevice(
    deviceno bigint,
    allow boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_MobileDevices SET
		Allow = center_updatemobiledevice.allow
	WHERE DeviceNo = center_updatemobiledevice.deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
