-- ─── FUNCTION: photoboardcmtdelete ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardcmtdelete(integer);
CREATE OR REPLACE FUNCTION public.photoboardcmtdelete(
    id integer
) RETURNS void
AS $function$
BEGIN
 DELETE FROM PhotoBoardCmt
WHERE ID = photoboardcmtdelete.id ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
