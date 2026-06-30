-- ─── FUNCTION: mail_getmailemlfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailemlfile(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailemlfile(
    mailno bigint
) RETURNS TABLE(
    mailno text,
    popuser text,
    todomain text,
    emlfilename text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT MailNo, P.PopUser, M.ToDomain, EmlFileName
	FROM Mail_Mails M
	INNER JOIN Mail_Accounts P ON P.AccountNo = M.AccNo
	WHERE M.MailNo = mail_getmailemlfile.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
