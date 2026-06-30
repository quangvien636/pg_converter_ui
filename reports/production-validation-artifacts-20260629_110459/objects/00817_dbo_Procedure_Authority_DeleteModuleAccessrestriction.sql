-- ─── PROCEDURE→FUNCTION: authority_deletemoduleaccessrestriction ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.authority_deletemoduleaccessrestriction(integer);
CREATE OR REPLACE FUNCTION public.authority_deletemoduleaccessrestriction(
    IN moduleaccessrestrictionno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Authority_ModuleAccessrestriction
	WHERE ModuleAccessrestrictionNo = authority_deletemoduleaccessrestriction.moduleaccessrestrictionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
