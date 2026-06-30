-- ─── PROCEDURE→FUNCTION: eapp_deleteiosdevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.eapp_deleteiosdevice(integer);
CREATE OR REPLACE FUNCTION public.eapp_deleteiosdevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM EAPP_IOSDevices WHERE UserNo = eapp_deleteiosdevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
