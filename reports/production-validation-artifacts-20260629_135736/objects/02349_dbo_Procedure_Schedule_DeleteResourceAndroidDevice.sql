-- ─── PROCEDURE→FUNCTION: schedule_deleteresourceandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteresourceandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourceandroiddevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleResourceAndroidDevices WHERE UserNo = schedule_deleteresourceandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
