-- ─── PROCEDURE→FUNCTION: mail_updatemail_important ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_updatemail_important(bigint, boolean);
CREATE OR REPLACE FUNCTION public.mail_updatemail_important(
    IN mailno bigint,
    IN isimportant boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Mail_Mails SET IsImportant = mail_updatemail_important.isimportant
	WHERE MailNo = mail_updatemail_important.mailno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
