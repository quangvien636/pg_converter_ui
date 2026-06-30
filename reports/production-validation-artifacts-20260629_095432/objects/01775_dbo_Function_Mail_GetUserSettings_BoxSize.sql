-- ─── FUNCTION: mail_getusersettings_boxsize ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getusersettings_boxsize();
CREATE OR REPLACE FUNCTION public.mail_getusersettings_boxsize(
) RETURNS TABLE(
    userno text,
    mailboxsize text,
    currentmailboxsize text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UserNo, MailBoxSize, CurrentMailBoxSize
	FROM Mail_UserSettings
	ORDER BY CurrentMailBoxSize DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
