-- ─── FUNCTION: mail_getusersetting_openmailboxs ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getusersetting_openmailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getusersetting_openmailboxs(
    userno integer
) RETURNS TABLE(
    openmailboxs text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT OpenMailBoxs
	FROM Mail_UserSettings
	WHERE UserNo = mail_getusersetting_openmailboxs.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
