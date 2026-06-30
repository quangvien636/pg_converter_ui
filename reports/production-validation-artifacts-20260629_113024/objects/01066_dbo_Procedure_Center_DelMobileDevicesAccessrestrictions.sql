-- ─── PROCEDURE→FUNCTION: center_delmobiledevicesaccessrestrictions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_delmobiledevicesaccessrestrictions(bigint);
CREATE OR REPLACE FUNCTION public.center_delmobiledevicesaccessrestrictions(
    IN deviceno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_MobileDevicesAccessrestrictions WHERE DeviceNo = center_delmobiledevicesaccessrestrictions.deviceno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
