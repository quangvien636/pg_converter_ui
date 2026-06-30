-- ─── FUNCTION: workingtime_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.workingtime_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_AndroidDevices WHERE UserNo = workingtime_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
