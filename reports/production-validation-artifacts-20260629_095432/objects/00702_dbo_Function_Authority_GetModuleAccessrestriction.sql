-- ─── FUNCTION: authority_getmoduleaccessrestriction ───────────────────────────────
DROP FUNCTION IF EXISTS public.authority_getmoduleaccessrestriction(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.authority_getmoduleaccessrestriction(
    applicationno integer,
    userno integer,
    departno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECt COUNT(ApplicationNo) FROM Authority_ModuleAccessrestriction
	WHERE (ApplicationNo = authority_getmoduleaccessrestriction.applicationno and UserNo = authority_getmoduleaccessrestriction.userno) OR
	(ApplicationNo = authority_getmoduleaccessrestriction.applicationno and DepartNo = authority_getmoduleaccessrestriction.departno);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
