-- ─── FUNCTION: workingtimev3_getpermisions ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_getpermisions();
CREATE OR REPLACE FUNCTION public.workingtimev3_getpermisions(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT w.* FROM WorkingTimeV3_Permisions w;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
