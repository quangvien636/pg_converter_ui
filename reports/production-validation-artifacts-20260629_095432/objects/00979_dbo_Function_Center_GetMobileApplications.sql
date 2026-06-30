-- ─── FUNCTION: center_getmobileapplications ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getmobileapplications();
CREATE OR REPLACE FUNCTION public.center_getmobileapplications(
) RETURNS TABLE(
    applicationno text,
    projectcode text,
    status text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ApplicationNo, ProjectCode, Status
	FROM Center_MobileApplications;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
