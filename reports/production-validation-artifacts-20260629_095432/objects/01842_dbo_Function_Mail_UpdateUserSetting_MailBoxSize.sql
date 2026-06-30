-- ─── FUNCTION: mail_updateusersetting_mailboxsize ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updateusersetting_mailboxsize(integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_updateusersetting_mailboxsize(
    userno integer,
    mailboxsize bigint
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_UserSettings SET MailBoxSize = mail_updateusersetting_mailboxsize.mailboxsize
    WHERE UserNo = mail_updateusersetting_mailboxsize.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
