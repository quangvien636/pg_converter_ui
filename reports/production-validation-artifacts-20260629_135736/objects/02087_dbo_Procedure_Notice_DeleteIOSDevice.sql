-- ─── PROCEDURE→FUNCTION: notice_deleteiosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.notice_deleteiosdevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Notice_IOSDevices WHERE UserNo = notice_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
