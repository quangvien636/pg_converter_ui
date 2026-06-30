-- ─── FUNCTION: mail_getserver ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getserver(integer);
CREATE OR REPLACE FUNCTION public.mail_getserver(
    serverno integer
) RETURNS TABLE(
    serverhost text,
    maildomain text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ServerHost, MailDomain
	FROM Mail_Servers
	WHERE ServerNo = mail_getserver.serverno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
