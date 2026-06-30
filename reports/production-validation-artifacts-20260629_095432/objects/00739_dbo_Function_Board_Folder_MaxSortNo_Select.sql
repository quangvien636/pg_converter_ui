-- ─── FUNCTION: board_folder_maxsortno_select ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_folder_maxsortno_select(integer);
CREATE OR REPLACE FUNCTION public.board_folder_maxsortno_select(
    parentno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
RETURN QUERY
select max(SortNo) from Board_Folders where ParentNo= board_folder_maxsortno_select.parentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
