-- ─── FUNCTION: photoboardfileupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardfileupdate(integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardfileupdate(
    seq integer,
    parentid integer
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoardFile
 SET 
  ParentID = photoboardfileupdate.parentid,   /* PhotoBoard.id */
  FileName = FILENAME   
WHERE seq = photoboardfileupdate.seq ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
