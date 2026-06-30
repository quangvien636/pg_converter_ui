-- ─── FUNCTION: mail_updatemail_content ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemail_content(bigint, character varying, integer);
CREATE OR REPLACE FUNCTION public.mail_updatemail_content(
    mailno bigint,
    content character varying,
    size integer
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_Mails SET Content = mail_updatemail_content.content, Size = mail_updatemail_content.size WHERE MailNo = mail_updatemail_content.mailno

	UPDATE Mail_UserSettings
	SET CurrentMailBoxSize = CurrentMailBoxSize + Size
	WHERE UserNo in(select UserNo from Mail_Mails WHERE MailNo = mail_updatemail_content.mailno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
