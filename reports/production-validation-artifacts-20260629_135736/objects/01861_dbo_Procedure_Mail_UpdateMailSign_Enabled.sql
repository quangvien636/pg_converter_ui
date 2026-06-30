-- ─── PROCEDURE→FUNCTION: mail_updatemailsign_enabled ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailsign_enabled(integer, bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemailsign_enabled(
    IN userno integer,
    IN accno bigint,
    IN signno bigint
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_MailSigns SET Enabled = FALSE WHERE UserNo = mail_updatemailsign_enabled.userno AND AccNo = mail_updatemailsign_enabled.accno;
    UPDATE Mail_MailSigns SET Enabled = TRUE WHERE SignNo = mail_updatemailsign_enabled.signno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
