-- ─── PROCEDURE→FUNCTION: mail_deleteandroiddevice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deleteandroiddevice(integer);
CREATE OR REPLACE FUNCTION public.mail_deleteandroiddevice(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_AndroidDevices WHERE UserNo = mail_deleteandroiddevice.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
