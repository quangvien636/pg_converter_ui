-- ─── PROCEDURE→FUNCTION: organization_getuseraddfields ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getuseraddfields(character varying);
CREATE OR REPLACE FUNCTION public.organization_getuseraddfields(
    IN usernos character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


		RETURN QUERY
		select UserNo,Value from Organization_Users_Addfields 
		where UserNo in (select * from string_to_array(UserNos, ',')::integer[])
		and Key = Key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
