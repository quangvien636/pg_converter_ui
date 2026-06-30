-- ─── FUNCTION: mail_insertsharedaccounts ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_insertsharedaccounts(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertsharedaccounts(
    userno integer,
    departno integer,
    shareduserno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Mail_SharedAccounts(UserNo,SharedUserNo,DepartNo)
	values(UserNo,SharedUserNo,DepartNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
