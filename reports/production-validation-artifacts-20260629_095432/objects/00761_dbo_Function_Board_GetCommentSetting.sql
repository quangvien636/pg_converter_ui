-- ─── FUNCTION: board_getcommentsetting ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getcommentsetting(integer);
CREATE OR REPLACE FUNCTION public.board_getcommentsetting(
    boardno integer DEFAULT 1213
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT COUNT(*)  FROM 
	Board_CommentSetting BC

	WHERE  BC.BoardNo= board_getcommentsetting.boardno AND BC.IsDelete= FALSE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
