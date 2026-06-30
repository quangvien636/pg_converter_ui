-- ─── FUNCTION: center_getapplication ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getapplication(integer);
CREATE OR REPLACE FUNCTION public.center_getapplication(
    applicationno integer
) RETURNS TABLE(
    applicationno text,
    projectcode text,
    sortno text,
    status text,
    option text
)
AS $function$
BEGIN


	IF (ApplicationNo = 0) BEGIN
	
		RETURN QUERY
		SELECT ApplicationNo, ProjectCode, SortNo, Status, Option
		FROM Center_Applications
		WHERE ProjectCode = ProjectCode
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ApplicationNo, ProjectCode, SortNo, Status, Option
		FROM Center_Applications
		WHERE ApplicationNo = center_getapplication.applicationno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
