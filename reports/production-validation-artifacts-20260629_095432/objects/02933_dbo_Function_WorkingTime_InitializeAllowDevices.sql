-- ─── FUNCTION: workingtime_initializeallowdevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_initializeallowdevices(integer);
CREATE OR REPLACE FUNCTION public.workingtime_initializeallowdevices(
    allowdeviceno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_AllowDevices
	SET DeviceId = '', verson = ''
		WHERE AllowDeviceNo = workingtime_initializeallowdevices.allowdeviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
