-- ─── FUNCTION: mail_getlargefiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getlargefiles(bigint);
CREATE OR REPLACE FUNCTION public.mail_getlargefiles(
    mailno bigint
) RETURNS TABLE(
    fileno text,
    mailno text,
    name text,
    size text,
    expirationdate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FileNo, MailNo, Name, Size, ExpirationDate
	FROM Mail_MailLargeFiles
	WHERE MailNo = mail_getlargefiles.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
