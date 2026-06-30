-- ─── FUNCTION: crewchat_getalliosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getalliosdevice();
CREATE OR REPLACE FUNCTION public.crewchat_getalliosdevice(
) RETURNS TABLE(
    deviceno text,
    userno text,
    deviceid text,
    regdate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DeviceNo, UserNo, DeviceID, RegDate FROM CrewChat_IOSDevices;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
