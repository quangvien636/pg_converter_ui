-- ─── FUNCTION: mail_getmailnos_bytag ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailnos_bytag(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailnos_bytag(
    tagno bigint
) RETURNS TABLE(
    mailno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT MailNo
	FROM Mail_Mails
	WHERE TagNo = mail_getmailnos_bytag.tagno AND IsDelete = FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
