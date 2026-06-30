-- ─── PROCEDURE→FUNCTION: mail_getusersetting_openmailboxs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getusersetting_openmailboxs(integer);
CREATE OR REPLACE FUNCTION public.mail_getusersetting_openmailboxs(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT OpenMailBoxs
	FROM Mail_UserSettings
	WHERE UserNo = mail_getusersetting_openmailboxs.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
