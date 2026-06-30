-- ─── FUNCTION: board_getopenfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getopenfolder(integer);
CREATE OR REPLACE FUNCTION public.board_getopenfolder(
    userno integer DEFAULT 70
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT /* /* TOP 1 */ */ COALESCE(IsOpen,CAST('FALSE' AS BIT)) FROM Board_HistoryFolder WHERE UserNo=board_getopenfolder.userno AND IsOpen= FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
