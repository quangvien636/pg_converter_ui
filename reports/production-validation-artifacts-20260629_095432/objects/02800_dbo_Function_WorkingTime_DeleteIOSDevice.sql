-- ─── FUNCTION: workingtime_deleteiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.workingtime_deleteiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_IOSDevices WHERE UserNo = workingtime_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
