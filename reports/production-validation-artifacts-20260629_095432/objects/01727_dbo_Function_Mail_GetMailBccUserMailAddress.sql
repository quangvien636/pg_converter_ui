-- ─── FUNCTION: mail_getmailbccusermailaddress ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailbccusermailaddress(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailbccusermailaddress(
    userno integer
) RETURNS TABLE(
    mailaddress text,
    name text
)
AS $function$
BEGIN

       
	RETURN QUERY
	select U.MailAddress,U.Name from Mail_BccSetting B
	INNER JOIN Organization_Users U ON B.UserNo = U.UserNo
	where BccUserNo = mail_getmailbccusermailaddress.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
