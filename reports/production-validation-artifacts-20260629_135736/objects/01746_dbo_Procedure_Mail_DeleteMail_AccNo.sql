-- ─── PROCEDURE→FUNCTION: mail_deletemail_accno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemail_accno(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemail_accno(
    IN accountno bigint
) RETURNS void
AS $function$
BEGIN

	UPDATE Mail_Mails
	IsDelete := 1, TagNo = 0 ,DeleteDate = NOW();
	WHERE AccNo = mail_deletemail_accno.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
