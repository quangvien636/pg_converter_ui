-- ─── FUNCTION: schedule_deleteresourceandroiddevice ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteresourceandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourceandroiddevice(
    userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleResourceAndroidDevices WHERE UserNo = schedule_deleteresourceandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
