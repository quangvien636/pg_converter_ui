-- ─── PROCEDURE→FUNCTION: schedule_deleteresourceiosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteresourceiosdevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourceiosdevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleResourceIOSDevices WHERE UserNo = schedule_deleteresourceiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
