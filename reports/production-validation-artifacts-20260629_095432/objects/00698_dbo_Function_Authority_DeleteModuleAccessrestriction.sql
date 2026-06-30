-- ─── FUNCTION: authority_deletemoduleaccessrestriction ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_deletemoduleaccessrestriction(integer);
CREATE OR REPLACE FUNCTION public.authority_deletemoduleaccessrestriction(
    moduleaccessrestrictionno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM Authority_ModuleAccessrestriction
	WHERE ModuleAccessrestrictionNo = authority_deletemoduleaccessrestriction.moduleaccessrestrictionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
