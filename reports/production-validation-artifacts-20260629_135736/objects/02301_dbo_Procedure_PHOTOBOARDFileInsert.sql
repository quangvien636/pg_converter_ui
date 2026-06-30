-- ─── PROCEDURE→FUNCTION: photoboardfileinsert ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.photoboardfileinsert(integer, boolean);
CREATE OR REPLACE FUNCTION public.photoboardfileinsert(
    IN parentid integer,
    IN firstflag boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
