-- ─── FUNCTION: photoboardcmtinsert ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardcmtinsert(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.photoboardcmtinsert(
    parentid integer,
    writerid character varying,
    comment character varying
) RETURNS void
AS $function$
BEGIN
 INSERT INTO PhotoBoardCmt(
  ParentID,   
  WriterID,   
  Comment,   
  RegDate)   
VALUES (
  PARENTID,  
  WRITERID,  
  COMMENT,   
  NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
