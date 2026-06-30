-- ─── PROCEDURE→FUNCTION: workingtime_changepassword ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_changepassword(integer);
CREATE OR REPLACE FUNCTION public.workingtime_changepassword(
    IN userno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE Organization_Users
	Password := PassNew;
	WHERE UserNo=workingtime_changepassword.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
