-- ─── FUNCTION: mail_getusersetting_usesign ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getusersetting_usesign(integer);
CREATE OR REPLACE FUNCTION public.mail_getusersetting_usesign(
    userno integer
) RETURNS TABLE(
    usesign text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT UseSign
	FROM Mail_UserSettings
	WHERE UserNo = mail_getusersetting_usesign.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
