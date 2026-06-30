-- ─── FUNCTION: center_getcompanyinformationtolist ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getcompanyinformationtolist();
CREATE OR REPLACE FUNCTION public.center_getcompanyinformationtolist(
) RETURNS TABLE(
    infono text,
    key text,
    value text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT InfoNo, Key, Value
	FROM Center_CompanyInformation;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
