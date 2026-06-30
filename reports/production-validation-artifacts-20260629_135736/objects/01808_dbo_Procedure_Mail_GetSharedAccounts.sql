-- ─── PROCEDURE→FUNCTION: mail_getsharedaccounts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getsharedaccounts(integer, integer);
CREATE OR REPLACE FUNCTION public.mail_getsharedaccounts(
    IN userno integer,
    IN departno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	IF(DepartNo > 0)
	BEGIN
		RETURN QUERY
		SELECT SharedAccountNo, SharedUserNo
		FROM Mail_SharedAccounts
		WHERE UserNo = mail_getsharedaccounts.userno or DepartNo = mail_getsharedaccounts.departno
	END;
	ELSE
		RETURN QUERY
		SELECT SharedAccountNo, SharedUserNo
		FROM Mail_SharedAccounts
		WHERE UserNo = mail_getsharedaccounts.userno
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
