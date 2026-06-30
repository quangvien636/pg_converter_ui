-- ─── PROCEDURE→FUNCTION: photoboardloginsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardloginsert(integer, character varying);
CREATE OR REPLACE FUNCTION public.photoboardloginsert(
    IN parentid integer,
    IN viewerid character varying
) RETURNS void
AS $function$
BEGIN
 INSERT INTO PhotoBoardLog(
  ParentID,   /* PhotoBoard.id */
  ViewerID,   
  ViewTime)   
VALUES (
  PARENTID,   /* PhotoBoard.id */
  VIEWERID,  
  NOW());
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
