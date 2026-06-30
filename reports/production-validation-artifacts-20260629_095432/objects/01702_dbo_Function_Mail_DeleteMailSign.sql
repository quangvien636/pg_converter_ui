-- ─── FUNCTION: mail_deletemailsign ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemailsign(integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailsign(
    userno integer,
    signno bigint
) RETURNS void
AS $function$
BEGIN


    DELETE FROM Mail_MailSigns WHERE SignNo = mail_deletemailsign.signno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
