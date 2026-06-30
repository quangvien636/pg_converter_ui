-- ─── PROCEDURE→FUNCTION: photoboardfiledelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardfiledelete(integer);
CREATE OR REPLACE FUNCTION public.photoboardfiledelete(
    IN seq integer
) RETURNS void
AS $function$
BEGIN
 DELETE FROM PhotoBoardFile
WHERE seq = photoboardfiledelete.seq ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
