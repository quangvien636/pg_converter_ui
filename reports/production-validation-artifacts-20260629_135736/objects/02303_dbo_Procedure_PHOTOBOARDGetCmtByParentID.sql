-- ─── PROCEDURE→FUNCTION: photoboardgetcmtbyparentid ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.photoboardgetcmtbyparentid(integer, integer);
CREATE OR REPLACE FUNCTION public.photoboardgetcmtbyparentid(
    IN parentid integer,
    IN langindex integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT *,'' as UserName FROM PhotoBoardCmt WHERE ParentID=photoboardgetcmtbyparentid.parentid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
