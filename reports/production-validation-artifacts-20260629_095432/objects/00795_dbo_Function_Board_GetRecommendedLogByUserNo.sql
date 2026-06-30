-- ─── FUNCTION: board_getrecommendedlogbyuserno ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getrecommendedlogbyuserno(bigint, integer);
CREATE OR REPLACE FUNCTION public.board_getrecommendedlogbyuserno(
    contentno bigint,
    userno integer
) RETURNS TABLE(
    logno text,
    boardno text,
    contentno text,
    userno text,
    username text,
    positionno text,
    positionname text,
    departno text,
    departname text,
    recommendeddate text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT LogNo, BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName, DepartNo, DepartName,
		RecommendedDate
	FROM Board_RecommendedLogs
	WHERE ContentNo = board_getrecommendedlogbyuserno.contentno AND UserNo=board_getrecommendedlogbyuserno.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
