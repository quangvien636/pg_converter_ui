-- ─── FUNCTION: mail_getmailsigns ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailsigns(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailsigns(
    userno integer
) RETURNS TABLE(
    signno text,
    accno text,
    name text,
    content text,
    enabled text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SignNo, AccNo, Name, Content, Enabled
	FROM Mail_MailSigns
	WHERE UserNo = mail_getmailsigns.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
