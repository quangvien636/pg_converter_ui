-- ─── PROCEDURE→FUNCTION: mail_updatemail_cmsendnum ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemail_cmsendnum(bigint, bigint);
CREATE OR REPLACE FUNCTION public.mail_updatemail_cmsendnum(
    IN mailno bigint,
    IN cmsendnum bigint
) RETURNS void
AS $function$
BEGIN


    UPDATE Mail_Mails SET CMSendNum = mail_updatemail_cmsendnum.cmsendnum WHERE MailNo = mail_updatemail_cmsendnum.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
