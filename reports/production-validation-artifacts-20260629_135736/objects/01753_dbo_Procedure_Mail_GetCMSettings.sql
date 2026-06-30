-- ─── PROCEDURE→FUNCTION: mail_getcmsettings ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getcmsettings(integer);
CREATE OR REPLACE FUNCTION public.mail_getcmsettings(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT PopAcc, Domain, AutoYN, AutoMessage, AutoStartDate, AutoEndDate, MaxDisk, Forward, ForwardRemark
	FROM Mail_CMSettings
	WHERE UserNo = mail_getcmsettings.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
