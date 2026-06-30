-- ─── FUNCTION: center_insertnotificationdata ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_insertnotificationdata(character varying, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.center_insertnotificationdata(
    devicetype character varying,
    modulename character varying,
    projectid character varying,
    devicekey character varying
) RETURNS TABLE(
    notificationno text
)
AS $function$
DECLARE
    notificationno bigint;
BEGIN

	
	INSERT INTO Center_NotificationData (DeviceType, ModuleName, ProjectID, DeviceKey, JsonData)
	VALUES (DeviceType, ModuleName, ProjectID, DeviceKey, JsonData)


	SET NotificationNo = lastval()
	
	RETURN QUERY
	SELECT NotificationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
