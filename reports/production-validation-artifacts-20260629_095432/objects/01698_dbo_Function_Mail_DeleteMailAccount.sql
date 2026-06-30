-- ─── FUNCTION: mail_deletemailaccount ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletemailaccount(bigint);
CREATE OR REPLACE FUNCTION public.mail_deletemailaccount(
    accountno bigint
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
