-- ─── FUNCTION: crewchat_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.crewchat_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.crewchat_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM CrewChat_AndroidDevices
	WHERE UserNo = crewchat_deleteandroiddevice.userno AND DeviceID = DeviceID;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
