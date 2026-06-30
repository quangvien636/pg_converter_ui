-- ─── PROCEDURE→FUNCTION: organization_get_scalar_useraddfields ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_get_scalar_useraddfields(integer);
CREATE OR REPLACE FUNCTION public.organization_get_scalar_useraddfields(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		RETURN QUERY
		select Value from Organization_Users_Addfields 
		where UserNo = organization_get_scalar_useraddfields.userno
		and Key = Key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
