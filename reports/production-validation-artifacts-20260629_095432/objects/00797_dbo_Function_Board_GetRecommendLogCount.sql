-- ─── FUNCTION: board_getrecommendlogcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getrecommendlogcount(bigint);
CREATE OR REPLACE FUNCTION public.board_getrecommendlogcount(
    contentno bigint DEFAULT 524
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT Count(*)
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendlogcount.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
