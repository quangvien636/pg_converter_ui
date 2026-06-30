-- ─── FUNCTION: center_getmobileapplication ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getmobileapplication(integer);
CREATE OR REPLACE FUNCTION public.center_getmobileapplication(
    applicationno integer
) RETURNS TABLE(
    applicationno text,
    projectcode text,
    status text
)
AS $function$
BEGIN


	IF (ApplicationNo = 0) BEGIN
	
		RETURN QUERY
		SELECT ApplicationNo, ProjectCode, Status
		FROM Center_MobileApplications
		WHERE ProjectCode = ProjectCode
	
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT ApplicationNo, ProjectCode, Status
		FROM Center_MobileApplications
		WHERE ApplicationNo = center_getmobileapplication.applicationno
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
