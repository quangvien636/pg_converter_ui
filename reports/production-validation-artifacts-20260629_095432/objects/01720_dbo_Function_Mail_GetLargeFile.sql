-- ─── FUNCTION: mail_getlargefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getlargefile(bigint);
CREATE OR REPLACE FUNCTION public.mail_getlargefile(
    fileno bigint
) RETURNS TABLE(
    mailno text,
    name text,
    size text,
    expirationdate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT MailNo, Name, Size, ExpirationDate
	FROM Mail_MailLargeFiles
	WHERE FileNo = mail_getlargefile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
