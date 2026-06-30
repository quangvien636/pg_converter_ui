-- ─── FUNCTION: mail_getmailcalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailcalendar(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailcalendar(
    mailno bigint
) RETURNS TABLE(
    mailno text,
    content text,
    isconvertxml text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT MailNo, Content, IsConvertXml
	FROM Mail_MailCalendars
	WHERE MailNo = mail_getmailcalendar.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
