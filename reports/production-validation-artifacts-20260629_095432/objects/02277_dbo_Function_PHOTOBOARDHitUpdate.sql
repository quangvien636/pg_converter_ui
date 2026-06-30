-- ─── FUNCTION: photoboardhitupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardhitupdate();
CREATE OR REPLACE FUNCTION public.photoboardhitupdate(
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoard
 SET 
  Hit = Hit+1   /* Á¶È¸¼ö */
WHERE ID = ID ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
