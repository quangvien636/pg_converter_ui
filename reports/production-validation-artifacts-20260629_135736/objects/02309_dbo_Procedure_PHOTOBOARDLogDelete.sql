-- ─── PROCEDURE→FUNCTION: photoboardlogdelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardlogdelete(integer);
CREATE OR REPLACE FUNCTION public.photoboardlogdelete(
    IN seq integer
) RETURNS void
AS $function$
BEGIN
 DELETE FROM PhotoBoardLog
WHERE seq = photoboardlogdelete.seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
