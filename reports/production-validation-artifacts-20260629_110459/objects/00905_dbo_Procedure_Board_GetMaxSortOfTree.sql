-- ─── PROCEDURE→FUNCTION: board_getmaxsortoftree ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_getmaxsortoftree(integer);
CREATE OR REPLACE FUNCTION public.board_getmaxsortoftree(
    IN parentno integer DEFAULT 115
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
WITH SORT AS(
select max(SortNo) AS SortNo from Board_Folders where ParentNo= board_getmaxsortoftree.parentno
UNION
select max(SortNo)  AS SortNo from Board_Boards where FolderNo = board_getmaxsortoftree.parentno)
RETURN QUERY
SELECT MAX(SortNo) FROM SORT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
