-- ─── FUNCTION: mail_updateusersetting_usesign ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updateusersetting_usesign(integer, boolean);
CREATE OR REPLACE FUNCTION public.mail_updateusersetting_usesign(
    userno integer,
    usesign boolean
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_UserSettings SET UseSign = mail_updateusersetting_usesign.usesign
    WHERE UserNo = mail_updateusersetting_usesign.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
