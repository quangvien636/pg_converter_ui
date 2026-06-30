-- ─── PROCEDURE→FUNCTION: mail_deletemailboxsharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemailboxsharer(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailboxsharer(
    IN boxno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_MailBoxSharers WHERE BoxNo = mail_deletemailboxsharer.boxno
	
	UPDATE Mail_MailBoxs SET IsShare = FALSE WHERE BoxNo = mail_deletemailboxsharer.boxno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
