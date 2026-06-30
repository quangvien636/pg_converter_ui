-- ─── FUNCTION: board_getcontentsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getcontentsetting(integer);
CREATE OR REPLACE FUNCTION public.board_getcontentsetting(
    boardno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
SELECT /* /* TOP 1 */ */* FROM public."Board_ContentSetting" WHERE BoardNo= board_getcontentsetting.boardno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
