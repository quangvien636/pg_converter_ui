-- ─── PROCEDURE→FUNCTION: mail_updatesentlog_iscancel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatesentlog_iscancel(bigint, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatesentlog_iscancel(
    IN logno bigint,
    IN iscancel boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_SentLogs SET IsCancel = mail_updatesentlog_iscancel.iscancel WHERE LogNo = mail_updatesentlog_iscancel.logno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
