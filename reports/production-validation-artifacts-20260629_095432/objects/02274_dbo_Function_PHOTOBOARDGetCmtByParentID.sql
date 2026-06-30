-- ─── FUNCTION: photoboardgetcmtbyparentid ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardgetcmtbyparentid(integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardgetcmtbyparentid(
    parentid integer,
    langindex integer
) RETURNS TABLE(
    col1 text,
    username text
)
AS $function$
BEGIN

RETURN QUERY
SELECT *,'' as UserName FROM PhotoBoardCmt WHERE ParentID=photoboardgetcmtbyparentid.parentid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
