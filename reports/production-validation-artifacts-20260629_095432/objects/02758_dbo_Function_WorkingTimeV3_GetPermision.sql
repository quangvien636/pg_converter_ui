-- ─── FUNCTION: workingtimev3_getpermision ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_getpermision(integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getpermision(
    p_uno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT w.* FROM WorkingTimeV3_Permisions w 
	where w.UserNo = workingtimev3_getpermision.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
