-- ─── FUNCTION: crewchat_getallandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_getallandroiddevice();
CREATE OR REPLACE FUNCTION public.crewchat_getallandroiddevice(
) RETURNS TABLE(
    deviceno text,
    userno text,
    deviceid text,
    regdate text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT DeviceNo, UserNo, DeviceID, RegDate FROM CrewChat_AndroidDevices;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
