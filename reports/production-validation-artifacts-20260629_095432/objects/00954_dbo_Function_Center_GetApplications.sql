-- ─── FUNCTION: center_getapplications ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getapplications();
CREATE OR REPLACE FUNCTION public.center_getapplications(
) RETURNS TABLE(
    applicationno text,
    projectcode text,
    sortno text,
    status text,
    option text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ApplicationNo, ProjectCode, SortNo, Status, Option
	FROM Center_Applications
	ORDER BY SortNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
