-- ─── FUNCTION: mail_getmailnos_forbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailnos_forbox(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailnos_forbox(
    boxno bigint
) RETURNS TABLE(
    mailno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT MailNo
	FROM Mail_Mails
	WHERE BoxNo = mail_getmailnos_forbox.boxno AND IsDelete = FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
