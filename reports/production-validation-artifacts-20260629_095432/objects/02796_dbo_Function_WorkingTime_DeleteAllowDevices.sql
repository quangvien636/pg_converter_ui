-- ─── FUNCTION: workingtime_deleteallowdevices ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_deleteallowdevices(integer);
CREATE OR REPLACE FUNCTION public.workingtime_deleteallowdevices(
    allowdeviceno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_AllowDevices
		WHERE AllowDeviceNo = workingtime_deleteallowdevices.allowdeviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
