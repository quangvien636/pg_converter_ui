-- ─── PROCEDURE→FUNCTION: mail_deletemailaccount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletemailaccount(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailaccount(
    IN accountno bigint
) RETURNS void
AS $function$
BEGIN

	INSERT INTO Mail_Accounts_Delete
	SELECT * FROM Mail_Accounts WHERE AccountNo = mail_deletemailaccount.accountno

	DELETE FROM Mail_Accounts WHERE AccountNo = mail_deletemailaccount.accountno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
