-- ─── FUNCTION: mail_updatemailcalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailcalendar(bigint, character varying, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemailcalendar(
    mailno bigint,
    content character varying,
    isconvertxml boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_MailCalendars SET Content = mail_updatemailcalendar.content, IsConvertXml = mail_updatemailcalendar.isconvertxml
	WHERE MailNo = mail_updatemailcalendar.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
