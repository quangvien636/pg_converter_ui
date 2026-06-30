-- ─── PROCEDURE→FUNCTION: center_updatemobiledevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updatemobiledevice(bigint, boolean);
CREATE OR REPLACE FUNCTION public.center_updatemobiledevice(
    IN deviceno bigint,
    IN allow boolean
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
