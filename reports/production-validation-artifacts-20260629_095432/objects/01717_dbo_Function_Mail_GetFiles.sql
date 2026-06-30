-- ─── FUNCTION: mail_getfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getfiles(bigint);
CREATE OR REPLACE FUNCTION public.mail_getfiles(
    mailno bigint
) RETURNS TABLE(
    fileno text,
    mailno text,
    userno text,
    issent text,
    todomain text,
    emlfilename text,
    name text,
    size text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT F.FileNo, M.MailNo, M.UserNo, M.IsSent, M.ToDomain, M.EmlFileName, F.Name, F.Size
	FROM Mail_MailFiles F 
	INNER JOIN Mail_Mails M ON M.MailNo = F.MailNo
	WHERE F.MailNo = mail_getfiles.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
