-- ─── PROCEDURE→FUNCTION: center_insertmobiledevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_insertmobiledevice(character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertmobiledevice(
    IN osversion character varying,
    IN allow boolean
) RETURNS SETOF record
AS $function$
DECLARE
    serialnumber character varying;
    deviceno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



_NEWID:

	SerialNumber := SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 12);
	DeviceNo := (SELECT DeviceNo FROM Center_MobileDevices WHERE SerialNumber = SerialNumber);
	IF DeviceNo IS NULL THEN

		INSERT INTO Center_MobileDevices (SerialNumber, OSVersion, Allow)
		VALUES (SerialNumber, OSVersion, Allow)
		
		DeviceNo := lastval();
	END IF;
	
	ELSE BEGIN
	
		GOTO _NEWID
	
	END;
	
	RETURN QUERY
	SELECT DeviceNo, SerialNumber, OSVersion, Allow
	FROM Center_MobileDevices
	WHERE DeviceNo = DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
