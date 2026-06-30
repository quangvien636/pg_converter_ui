-- ─── FUNCTION: board_countboardinfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_countboardinfolder(integer);
CREATE OR REPLACE FUNCTION public.board_countboardinfolder(
    folderno integer DEFAULT 96
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

RETURN QUERY
SELECT Count (*)
  FROM Board_Boards Where FolderNo=board_countboardinfolder.folderno and Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
