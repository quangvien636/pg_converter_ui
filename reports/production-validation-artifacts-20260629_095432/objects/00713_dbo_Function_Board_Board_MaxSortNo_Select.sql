-- ─── FUNCTION: board_board_maxsortno_select ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_board_maxsortno_select(integer);
CREATE OR REPLACE FUNCTION public.board_board_maxsortno_select(
    folderno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN
RETURN QUERY
select max(SortNo) from Board_Folders where FolderNo= board_board_maxsortno_select.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
