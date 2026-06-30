-- ─── PROCEDURE→FUNCTION: board_folder_maxsortno_select ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_folder_maxsortno_select(integer);
CREATE OR REPLACE FUNCTION public.board_folder_maxsortno_select(
    IN parentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
RETURN QUERY
select max(SortNo) from Board_Folders where ParentNo= board_folder_maxsortno_select.parentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
