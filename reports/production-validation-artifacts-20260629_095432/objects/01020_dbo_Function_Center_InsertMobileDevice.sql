-- ─── FUNCTION: center_insertmobiledevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertmobiledevice(character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertmobiledevice(
    osversion character varying,
    allow boolean
) RETURNS TABLE(
    deviceno text,
    serialnumber text,
    osversion text,
    allow text
)
AS $function$
DECLARE
    serialnumber character varying;
    deviceno bigint;
BEGIN



_NEWID:

	SET SerialNumber = SUBSTRING(REPLACE(NEWID(), '-', ''), 1, 12)


	SET DeviceNo = (SELECT DeviceNo FROM Center_MobileDevices WHERE SerialNumber = SerialNumber)
	
	IF (DeviceNo IS NULL) BEGIN

		INSERT INTO Center_MobileDevices (SerialNumber, OSVersion, Allow)
		VALUES (SerialNumber, OSVersion, Allow)
		
		SET DeviceNo = lastval()
	
	END
	
	ELSE BEGIN
	
		GOTO _NEWID
	
	END
	
	RETURN QUERY
	SELECT DeviceNo, SerialNumber, OSVersion, Allow
	FROM Center_MobileDevices
	WHERE DeviceNo = DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
