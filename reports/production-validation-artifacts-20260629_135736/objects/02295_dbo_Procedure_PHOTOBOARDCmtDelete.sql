-- ─── PROCEDURE→FUNCTION: photoboardcmtdelete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardcmtdelete(integer);
CREATE OR REPLACE FUNCTION public.photoboardcmtdelete(
    IN id integer
) RETURNS void
AS $function$
BEGIN
 DELETE FROM PhotoBoardCmt
WHERE ID = photoboardcmtdelete.id ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
