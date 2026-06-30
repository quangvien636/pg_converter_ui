-- ─── PROCEDURE→FUNCTION: mail_getusersettings_boxsize ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getusersettings_boxsize();
CREATE OR REPLACE FUNCTION public.mail_getusersettings_boxsize(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT UserNo, MailBoxSize, CurrentMailBoxSize
	FROM Mail_UserSettings
	ORDER BY CurrentMailBoxSize DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
