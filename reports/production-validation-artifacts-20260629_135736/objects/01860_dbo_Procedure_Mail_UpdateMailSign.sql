-- ─── PROCEDURE→FUNCTION: mail_updatemailsign ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemailsign(bigint, character varying);
CREATE OR REPLACE FUNCTION public.mail_updatemailsign(
    IN signno bigint,
    IN name character varying
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_MailSigns SET Name = mail_updatemailsign.name, Content = Content
    WHERE SignNo = mail_updatemailsign.signno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
