-- ─── FUNCTION: mail_getmailsign ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailsign(bigint);
CREATE OR REPLACE FUNCTION public.mail_getmailsign(
    signno bigint
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
	WHERE SignNo = mail_getmailsign.signno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
