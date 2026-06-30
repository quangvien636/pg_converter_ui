-- ─── FUNCTION: board_getrecommendcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getrecommendcount(bigint);
CREATE OR REPLACE FUNCTION public.board_getrecommendcount(
    contentno bigint DEFAULT 5721
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CAST( Count(*) AS BIGINT)
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendcount.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
