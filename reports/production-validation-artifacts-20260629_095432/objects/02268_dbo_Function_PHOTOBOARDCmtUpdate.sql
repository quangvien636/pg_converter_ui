-- ─── FUNCTION: photoboardcmtupdate ───────────────────────────────
DROP FUNCTION IF EXISTS public.photoboardcmtupdate(integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.photoboardcmtupdate(
    id integer,
    parentid integer,
    writerid character varying,
    comment character varying
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoardCmt
 SET 
  ParentID = photoboardcmtupdate.parentid,   
  WriterID = photoboardcmtupdate.writerid,  
  Comment = photoboardcmtupdate.comment  
WHERE ID = photoboardcmtupdate.id ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
