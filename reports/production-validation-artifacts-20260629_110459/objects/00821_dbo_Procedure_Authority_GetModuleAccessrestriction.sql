-- ─── PROCEDURE→FUNCTION: authority_getmoduleaccessrestriction ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.authority_getmoduleaccessrestriction(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.authority_getmoduleaccessrestriction(
    IN applicationno integer,
    IN userno integer,
    IN departno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECt COUNT(ApplicationNo) FROM Authority_ModuleAccessrestriction
	WHERE (ApplicationNo = authority_getmoduleaccessrestriction.applicationno and UserNo = authority_getmoduleaccessrestriction.userno) OR
	(ApplicationNo = authority_getmoduleaccessrestriction.applicationno and DepartNo = authority_getmoduleaccessrestriction.departno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
