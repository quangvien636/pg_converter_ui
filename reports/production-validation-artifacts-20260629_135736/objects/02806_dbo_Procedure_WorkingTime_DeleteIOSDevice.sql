-- ─── PROCEDURE→FUNCTION: workingtime_deleteiosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.workingtime_deleteiosdevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkingTime_IOSDevices WHERE UserNo = workingtime_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
