-- ─── FUNCTION: center_insertmobiledevice_all ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertmobiledevice_all(character varying, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_insertmobiledevice_all(
    serialnumber character varying,
    osversion character varying,
    allow boolean
) RETURNS TABLE(
    deviceno text
)
AS $function$
DECLARE
    deviceno bigint;
BEGIN


	INSERT INTO Center_MobileDevices (SerialNumber, OSVersion, Allow)
	VALUES (SerialNumber, OSVersion, Allow)


	SET DeviceNo = lastval()
	
	RETURN QUERY
	SELECT DeviceNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
