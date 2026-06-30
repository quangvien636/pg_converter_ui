-- ─── FUNCTION: crewchat_insertpcdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_insertpcdevice(character varying, boolean);
CREATE OR REPLACE FUNCTION public.crewchat_insertpcdevice(
    macaddress character varying,
    allow boolean
) RETURNS TABLE(
    deviceno text,
    serialnumber text,
    macaddress text,
    allow text
)
AS $function$
DECLARE
    serialnumber character varying;
    myid uuid;
    deviceno bigint;
BEGIN




	SET myid = NEWID()
	
_NEWID:

	SET SerialNumber = CONVERT(varchar(255), SUBSTRING(REPLACE(myid, '-', ''), 1, 32))

	SET DeviceNo = (SELECT DeviceNo FROM CrewChat_PCDevices WHERE SerialNumber = SerialNumber)
	
	IF (DeviceNo IS NULL) BEGIN
		--값이 중복되지 않으므로 INSERT INTO 합니다.;
		INSERT INTO CrewChat_PCDevices (MacAddress, SerialNumber, Allow)
		VALUES (MacAddress, SerialNumber, Allow)
		
		SET DeviceNo = lastval()
	
	END
	
	ELSE BEGIN
		--값이 중복되므로 다시 _NEWID 루프로 이동합니다.
		GOTO _NEWID
	
	END
	
	RETURN QUERY
	SELECT DeviceNo, SerialNumber, MacAddress, Allow
	FROM CrewChat_PCDevices
	WHERE DeviceNo = DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
