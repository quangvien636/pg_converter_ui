-- ─── PROCEDURE→FUNCTION: center_insertmobiledevice_all ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertmobiledevice_all(character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertmobiledevice_all(
    IN serialnumber character varying,
    IN osversion character varying,
    IN allow boolean
) RETURNS SETOF record
AS $function$
DECLARE
    deviceno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Center_MobileDevices (SerialNumber, OSVersion, Allow)
	VALUES (SerialNumber, OSVersion, Allow)


	DeviceNo := lastval();
	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
