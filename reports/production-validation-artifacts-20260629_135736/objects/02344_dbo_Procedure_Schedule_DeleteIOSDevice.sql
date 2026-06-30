-- ─── PROCEDURE→FUNCTION: schedule_deleteiosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteiosdevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Schedule_IOSDevices WHERE UserNo = schedule_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
