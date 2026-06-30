-- ─── PROCEDURE→FUNCTION: photoboardlogupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardlogupdate(integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardlogupdate(
    IN seq integer,
    IN parentid integer
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoardLog
 SET 
 -- seq = SEQ,  
  ParentID = photoboardlogupdate.parentid,   /* PhotoBoard.id */
  ViewerID = VIEWERID,  
  ViewTime = NOW()  
WHERE seq = photoboardlogupdate.seq ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
