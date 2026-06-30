-- ─── FUNCTION: photoboardfiledelete ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardfiledelete(integer);
CREATE OR REPLACE FUNCTION public.photoboardfiledelete(
    seq integer
) RETURNS void
AS $function$
BEGIN
 DELETE FROM PhotoBoardFile
WHERE seq = photoboardfiledelete.seq ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
