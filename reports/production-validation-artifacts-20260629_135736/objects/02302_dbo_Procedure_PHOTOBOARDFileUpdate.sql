-- ─── PROCEDURE→FUNCTION: photoboardfileupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardfileupdate(integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardfileupdate(
    IN seq integer,
    IN parentid integer
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoardFile
 ParentID := photoboardfileupdate.parentid,   /* PhotoBoard.id */;
  FileName = FILENAME   
WHERE seq = photoboardfileupdate.seq ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
