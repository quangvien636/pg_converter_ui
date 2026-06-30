-- ─── PROCEDURE→FUNCTION: photoboardhitupdate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.photoboardhitupdate();
CREATE OR REPLACE FUNCTION public.photoboardhitupdate(
) RETURNS void
AS $function$
BEGIN
UPDATE PhotoBoard
 Hit := Hit+1   /* Á¶È¸¼ö */;
WHERE ID = ID ;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
