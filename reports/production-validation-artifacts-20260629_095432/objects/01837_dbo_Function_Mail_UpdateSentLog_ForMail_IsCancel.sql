-- ─── FUNCTION: mail_updatesentlog_formail_iscancel ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatesentlog_formail_iscancel(bigint, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatesentlog_formail_iscancel(
    mailno bigint,
    iscancel boolean
) RETURNS void
AS $function$
BEGIN


	IF (IsCancel = TRUE) BEGIN
	
		UPDATE Mail_SentLogs SET IsComplete = FALSE, IsCancel = TRUE
		WHERE MailNo = mail_updatesentlog_formail_iscancel.mailno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
