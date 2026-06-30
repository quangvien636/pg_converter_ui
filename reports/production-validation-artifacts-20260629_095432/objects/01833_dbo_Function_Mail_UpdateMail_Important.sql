-- ─── FUNCTION: mail_updatemail_important ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail_important(bigint, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemail_important(
    mailno bigint,
    isimportant boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Mails SET IsImportant = mail_updatemail_important.isimportant
	WHERE MailNo = mail_updatemail_important.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
