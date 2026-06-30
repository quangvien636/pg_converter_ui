-- ─── FUNCTION: mail_getservers ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getservers();
CREATE OR REPLACE FUNCTION public.mail_getservers(
) RETURNS TABLE(
    serverno text,
    serverhost text,
    maildomain text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ServerNo, ServerHost, MailDomain
	FROM Mail_Servers;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
