-- ─── PROCEDURE→FUNCTION: center_getuserfailedloginlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getuserfailedloginlist();
CREATE OR REPLACE FUNCTION public.center_getuserfailedloginlist(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	select UserNo,UserID,Name,FailedLoginCount from Organization_Users
	where FailedLoginCount >= (select Value from Center_Configuration where key = 'KEY_Use_LOGIN_PasswordMust_Cnt');
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
