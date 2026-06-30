-- ─── PROCEDURE→FUNCTION: mail_insertsharedaccounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.mail_insertsharedaccounts(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.mail_insertsharedaccounts(
    IN userno integer,
    IN departno integer,
    IN shareduserno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO Mail_SharedAccounts(UserNo,SharedUserNo,DepartNo)
	values(UserNo,SharedUserNo,DepartNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
