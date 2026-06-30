-- ─── PROCEDURE→FUNCTION: board_getopenfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_getopenfolder(integer);
CREATE OR REPLACE FUNCTION public.board_getopenfolder(
    IN userno integer DEFAULT 70
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT /* /* TOP 1 */ */ COALESCE(IsOpen,CAST('FALSE' AS BIT)) FROM Board_HistoryFolder WHERE UserNo=board_getopenfolder.userno AND IsOpen= FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
