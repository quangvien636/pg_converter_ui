-- ─── FUNCTION: schedule_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Schedule_IOSDevices WHERE UserNo = schedule_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
