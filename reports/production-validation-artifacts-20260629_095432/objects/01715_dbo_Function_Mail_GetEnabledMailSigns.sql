-- ─── FUNCTION: mail_getenabledmailsigns ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getenabledmailsigns(integer);
CREATE OR REPLACE FUNCTION public.mail_getenabledmailsigns(
    userno integer
) RETURNS TABLE(
    signno text,
    accno text,
    name text,
    content text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SignNo, AccNo, Name, Content
	FROM Mail_MailSigns
	WHERE UserNo = mail_getenabledmailsigns.userno AND Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
