-- ─── FUNCTION: photoboardlogdelete ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardlogdelete(integer);
CREATE OR REPLACE FUNCTION public.photoboardlogdelete(
    seq integer
) RETURNS void
AS $function$
BEGIN
 DELETE FROM PhotoBoardLog
WHERE seq = photoboardlogdelete.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
