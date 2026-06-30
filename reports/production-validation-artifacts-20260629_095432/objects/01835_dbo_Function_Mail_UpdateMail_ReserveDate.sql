-- ─── FUNCTION: mail_updatemail_reservedate ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail_reservedate(bigint, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.mail_updatemail_reservedate(
    mailno bigint,
    reservedate timestamp without time zone
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Mails SET ReserveDate = mail_updatemail_reservedate.reservedate WHERE MailNo = mail_updatemail_reservedate.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
