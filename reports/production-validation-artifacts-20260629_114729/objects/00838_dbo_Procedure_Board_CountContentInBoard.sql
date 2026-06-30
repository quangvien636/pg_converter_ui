-- ─── PROCEDURE→FUNCTION: board_countcontentinboard ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_countcontentinboard(integer);
CREATE OR REPLACE FUNCTION public.board_countcontentinboard(
    IN boardno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT Count (*)
  FROM Board_Contents Where BoardNo=board_countcontentinboard.boardno and Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
