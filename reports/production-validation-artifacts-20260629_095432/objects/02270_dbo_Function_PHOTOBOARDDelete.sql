-- ─── FUNCTION: photoboarddelete ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboarddelete(integer);
CREATE OR REPLACE FUNCTION public.photoboarddelete(
    id integer
) RETURNS void
AS $function$
BEGIN
 DELETE FROM PhotoBoard
WHERE ID = photoboarddelete.id ;;
 DELETE FROM PhotoBoardFile
WHERE PhotoBoardFile.ParentID = photoboarddelete.id;;
 DELETE FROM PhotoBoardCmt
WHERE PhotoBoardCmt.ParentID = photoboarddelete.id;;
 DELETE FROM PhotoBoardLog
WHERE PhotoBoardLog.ParentID = photoboarddelete.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
