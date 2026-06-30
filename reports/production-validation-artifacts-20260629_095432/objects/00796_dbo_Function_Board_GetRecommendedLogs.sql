-- ─── FUNCTION: board_getrecommendedlogs ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_getrecommendedlogs(bigint);
CREATE OR REPLACE FUNCTION public.board_getrecommendedlogs(
    contentno bigint DEFAULT 8
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
	WHERE ContentNo = board_getrecommendedlogs.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
