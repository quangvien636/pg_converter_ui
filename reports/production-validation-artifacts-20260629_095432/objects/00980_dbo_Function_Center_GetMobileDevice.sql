-- ─── FUNCTION: center_getmobiledevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getmobiledevice();
CREATE OR REPLACE FUNCTION public.center_getmobiledevice(
) RETURNS TABLE(
    deviceno text,
    osversion text,
    allow text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DeviceNo, OSVersion, Allow
	FROM Center_MobileDevices
	WHERE SerialNumber = SerialNumber;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
