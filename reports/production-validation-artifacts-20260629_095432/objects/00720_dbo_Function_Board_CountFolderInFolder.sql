-- ─── FUNCTION: board_countfolderinfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_countfolderinfolder(integer);
CREATE OR REPLACE FUNCTION public.board_countfolderinfolder(
    folderno integer DEFAULT 114
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN

RETURN QUERY
SELECT Count (*)
  FROM Board_Folders Where ParentNo=board_countfolderinfolder.folderno and Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
