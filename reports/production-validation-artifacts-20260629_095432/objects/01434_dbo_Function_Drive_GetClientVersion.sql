-- ─── FUNCTION: drive_getclientversion ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getclientversion();
CREATE OR REPLACE FUNCTION public.drive_getclientversion(
) RETURNS TABLE(
    clientversion text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ClientVersion FROM Drive_Versions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
