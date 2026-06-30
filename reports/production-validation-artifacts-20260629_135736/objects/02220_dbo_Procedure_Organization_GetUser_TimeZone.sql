-- ─── PROCEDURE→FUNCTION: organization_getuser_timezone ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getuser_timezone(integer);
CREATE OR REPLACE FUNCTION public.organization_getuser_timezone(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		
	RETURN QUERY
	SELECT TimeZone
	FROM Organization_Users
	WHERE UserNo = organization_getuser_timezone.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
