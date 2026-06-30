-- ─── FUNCTION: board_insertrecommendedlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertrecommendedlog(integer, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.board_insertrecommendedlog(
    boardno integer,
    contentno bigint,
    userno integer,
    username character varying,
    positionno integer,
    positionname character varying,
    departno integer,
    departname character varying,
    recommendeddate timestamp without time zone
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    logno bigint;
BEGIN


	IF (SELECT COUNT(*) FROM Board_RecommendedLogs WHERE ContentNo = board_insertrecommendedlog.contentno AND UserNo = board_insertrecommendedlog.userno) != 0 BEGIN;
		DELETE FROM public."Board_RecommendedLogs" WHERE ContentNo = board_insertrecommendedlog.contentno AND UserNo = board_insertrecommendedlog.userno;
		UPDATE Board_Contents SET RecommendedCount = RecommendedCount -1 WHERE ContentNo = board_insertrecommendedlog.contentno
		RETURN QUERY
		SELECT CONVERT(BIGINT, 0);
		END
	ELSE
	BEGIN
	
	UPDATE Board_Contents SET RecommendedCount = RecommendedCount + 1 WHERE ContentNo = board_insertrecommendedlog.contentno

	INSERT INTO Board_RecommendedLogs (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
		DepartNo, DepartName, RecommendedDate)
	VALUES (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
		DepartNo, DepartName, RecommendedDate)
		

	SET LogNo = lastval()
	
	RETURN QUERY
	SELECT LogNo;
	 END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
