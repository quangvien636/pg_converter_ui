-- ─── PROCEDURE→FUNCTION: photoboardcmtinsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardcmtinsert(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.photoboardcmtinsert(
    IN parentid integer,
    IN writerid character varying,
    IN comment character varying
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
