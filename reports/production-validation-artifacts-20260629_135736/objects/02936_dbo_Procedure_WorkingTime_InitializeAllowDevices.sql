-- ─── PROCEDURE→FUNCTION: workingtime_initializeallowdevices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_initializeallowdevices(integer);
CREATE OR REPLACE FUNCTION public.workingtime_initializeallowdevices(
    IN allowdeviceno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_AllowDevices
	DeviceId := '', verson = '';
		WHERE AllowDeviceNo = workingtime_initializeallowdevices.allowdeviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
