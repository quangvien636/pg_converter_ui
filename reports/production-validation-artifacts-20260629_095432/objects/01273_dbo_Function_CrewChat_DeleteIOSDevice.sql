-- ─── FUNCTION: crewchat_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.crewchat_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_IOSDevices
	WHERE UserNo = crewchat_deleteiosdevice.userno AND DeviceID = DeviceID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
