-- ─── PROCEDURE→FUNCTION: mail_deletemailsign ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemailsign(integer, bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailsign(
    IN userno integer,
    IN signno bigint
) RETURNS void
AS $function$
BEGIN


    DELETE FROM Mail_MailSigns WHERE SignNo = mail_deletemailsign.signno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
