-- ─── PROCEDURE→FUNCTION: eapp_deleteandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.eapp_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.eapp_deleteandroiddevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM EAPP_AndroidDevices WHERE UserNo = eapp_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
