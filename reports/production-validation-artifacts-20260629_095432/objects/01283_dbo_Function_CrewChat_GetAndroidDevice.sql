-- ─── FUNCTION: crewchat_getandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.crewchat_getandroiddevice(
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
	SELECT DeviceNo, UserNo, DeviceID, RegDate FROM CrewChat_AndroidDevices
	WHERE UserNo = crewchat_getandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
