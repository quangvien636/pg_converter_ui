-- ─── FUNCTION: photoboardcountallboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardcountallboard();
CREATE OR REPLACE FUNCTION public.photoboardcountallboard(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

RETURN QUERY
Select count(*) from PhotoBoard;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
