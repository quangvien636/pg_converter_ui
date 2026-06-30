-- ─── FUNCTION: mail_deletesharedaccounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_deletesharedaccounts(integer);
CREATE OR REPLACE FUNCTION public.mail_deletesharedaccounts(
    shareduserno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Mail_SharedAccounts
	where SharedUserNo = mail_deletesharedaccounts.shareduserno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
