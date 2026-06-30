-- ─── PROCEDURE→FUNCTION: mail_deletesharedaccounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_deletesharedaccounts(integer);
CREATE OR REPLACE FUNCTION public.mail_deletesharedaccounts(
    IN shareduserno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_SharedAccounts
	where SharedUserNo = mail_deletesharedaccounts.shareduserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
