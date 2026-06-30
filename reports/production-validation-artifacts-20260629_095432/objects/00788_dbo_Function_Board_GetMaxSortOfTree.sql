-- ─── FUNCTION: board_getmaxsortoftree ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getmaxsortoftree(integer);
CREATE OR REPLACE FUNCTION public.board_getmaxsortoftree(
    parentno integer DEFAULT 115
) RETURNS TABLE(
    col1 text
)
AS $function$
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
