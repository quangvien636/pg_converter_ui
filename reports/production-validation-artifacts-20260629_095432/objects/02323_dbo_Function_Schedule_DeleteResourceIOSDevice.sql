-- ─── FUNCTION: schedule_deleteresourceiosdevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteresourceiosdevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourceiosdevice(
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleResourceIOSDevices WHERE UserNo = schedule_deleteresourceiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
