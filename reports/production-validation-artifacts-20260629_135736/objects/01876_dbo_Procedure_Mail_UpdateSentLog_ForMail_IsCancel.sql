-- ─── PROCEDURE→FUNCTION: mail_updatesentlog_formail_iscancel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatesentlog_formail_iscancel(bigint, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatesentlog_formail_iscancel(
    IN mailno bigint,
    IN iscancel boolean
) RETURNS void
AS $function$
BEGIN


	IF IsCancel = TRUE THEN
	
		UPDATE Mail_SentLogs SET IsComplete = FALSE, IsCancel = TRUE
		WHERE MailNo = mail_updatesentlog_formail_iscancel.mailno
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
