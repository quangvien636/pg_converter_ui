-- ─── FUNCTION: mail_updatemailsign_enabled ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_updatemailsign_enabled(integer, bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemailsign_enabled(
    userno integer,
    accno bigint,
    signno bigint
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_MailSigns SET Enabled = FALSE WHERE UserNo = mail_updatemailsign_enabled.userno AND AccNo = mail_updatemailsign_enabled.accno;
    UPDATE Mail_MailSigns SET Enabled = TRUE WHERE SignNo = mail_updatemailsign_enabled.signno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
