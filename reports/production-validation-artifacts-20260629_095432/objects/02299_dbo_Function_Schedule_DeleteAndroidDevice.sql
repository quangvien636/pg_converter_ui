-- ─── FUNCTION: schedule_deleteandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Schedule_AndroidDevices WHERE UserNo = schedule_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
