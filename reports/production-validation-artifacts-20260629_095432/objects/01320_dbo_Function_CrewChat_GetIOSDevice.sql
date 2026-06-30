-- ─── FUNCTION: crewchat_getiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getiosdevice(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getiosdevice(
    userno integer
) RETURNS TABLE(
    deviceno text,
    userno text,
    deviceid text,
    regdate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DeviceNo, UserNo, DeviceID, RegDate FROM CrewChat_IOSDevices
	WHERE UserNo = crewchat_getiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
