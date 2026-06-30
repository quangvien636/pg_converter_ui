-- ─── PROCEDURE→FUNCTION: crewchat_insertpcdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_insertpcdevice(character varying, boolean);
CREATE OR REPLACE FUNCTION public.crewchat_insertpcdevice(
    IN macaddress character varying,
    IN allow boolean
) RETURNS SETOF record
AS $function$
DECLARE
    serialnumber character varying;
    myid uuid;
    deviceno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN




	myid := NEWID();
_NEWID:

	SerialNumber := CONVERT(varchar(255), SUBSTRING(REPLACE(myid, '-', ''), 1, 32));
	DeviceNo := (SELECT DeviceNo FROM CrewChat_PCDevices WHERE SerialNumber = SerialNumber);
	IF DeviceNo IS NULL THEN
		--값이 중복되지 않으므로 INSERT INTO 합니다.;
		INSERT INTO CrewChat_PCDevices (MacAddress, SerialNumber, Allow)
		VALUES (MacAddress, SerialNumber, Allow)
		
		DeviceNo := lastval();
	END IF;
	
	ELSE BEGIN
		--값이 중복되므로 다시 _NEWID 루프로 이동합니다.
		GOTO _NEWID
	
	END;
	
	RETURN QUERY
	SELECT DeviceNo, SerialNumber, MacAddress, Allow
	FROM CrewChat_PCDevices
	WHERE DeviceNo = DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
