-- ─── PROCEDURE→FUNCTION: workingtime_deleteallowdevices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_deleteallowdevices(integer);
CREATE OR REPLACE FUNCTION public.workingtime_deleteallowdevices(
    IN allowdeviceno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM WorkingTime_AllowDevices
		WHERE AllowDeviceNo = workingtime_deleteallowdevices.allowdeviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
