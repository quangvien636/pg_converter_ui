-- ─── FUNCTION: board_countcontentinboard ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_countcontentinboard(integer);
CREATE OR REPLACE FUNCTION public.board_countcontentinboard(
    boardno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

RETURN QUERY
SELECT Count (*)
  FROM Board_Contents Where BoardNo=board_countcontentinboard.boardno and Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
