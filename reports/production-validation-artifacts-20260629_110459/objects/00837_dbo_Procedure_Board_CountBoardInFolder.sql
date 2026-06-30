-- ─── PROCEDURE→FUNCTION: board_countboardinfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_countboardinfolder(integer);
CREATE OR REPLACE FUNCTION public.board_countboardinfolder(
    IN folderno integer DEFAULT 96
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT Count (*)
  FROM Board_Boards Where FolderNo=board_countboardinfolder.folderno and Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
