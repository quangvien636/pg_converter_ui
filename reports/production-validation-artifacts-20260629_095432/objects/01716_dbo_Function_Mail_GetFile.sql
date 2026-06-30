-- ─── FUNCTION: mail_getfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getfile(bigint);
CREATE OR REPLACE FUNCTION public.mail_getfile(
    fileno bigint
) RETURNS TABLE(
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
	SELECT M.MailNo, M.UserNo, M.IsSent, M.ToDomain, M.EmlFileName, F.Name, F.Size
	FROM Mail_MailFiles F
	INNER JOIN Mail_Mails M ON M.MailNo = F.MailNo
	WHERE F.FileNo = mail_getfile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
