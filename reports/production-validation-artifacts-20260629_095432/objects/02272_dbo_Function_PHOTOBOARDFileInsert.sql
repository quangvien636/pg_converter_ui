-- ─── FUNCTION: photoboardfileinsert ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardfileinsert(integer, boolean);
CREATE OR REPLACE FUNCTION public.photoboardfileinsert(
    parentid integer,
    firstflag boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
 INSERT INTO PhotoBoardFile(
  ParentID,   /* PhotoBoard.id */
  FileName,
  FirstFlag)  
VALUES (
  PARENTID,   /* PhotoBoard.id */
  FILENAME,
  FIRSTFLAG);  


  RETURN QUERY
  SELECT @IDENTITY;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
