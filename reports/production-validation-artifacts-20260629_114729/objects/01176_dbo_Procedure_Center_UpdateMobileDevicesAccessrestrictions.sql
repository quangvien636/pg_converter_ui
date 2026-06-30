-- ─── PROCEDURE→FUNCTION: center_updatemobiledevicesaccessrestrictions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_updatemobiledevicesaccessrestrictions(bigint, boolean);
CREATE OR REPLACE FUNCTION public.center_updatemobiledevicesaccessrestrictions(
    IN deviceno bigint,
    IN enabled boolean
) RETURNS void
AS $function$
BEGIN


	update Center_MobileDevicesAccessrestrictions set Enabled = center_updatemobiledevicesaccessrestrictions.enabled WHERE DeviceNo = center_updatemobiledevicesaccessrestrictions.deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
