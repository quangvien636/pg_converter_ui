-- ─── PROCEDURE→FUNCTION: board_insertrecommendedlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertrecommendedlog(integer, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.board_insertrecommendedlog(
    IN boardno integer,
    IN contentno bigint,
    IN userno integer,
    IN username character varying,
    IN positionno integer,
    IN positionname character varying,
    IN departno integer,
    IN departname character varying,
    IN recommendeddate timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Board_RecommendedLogs WHERE ContentNo = board_insertrecommendedlog.contentno AND UserNo = board_insertrecommendedlog.userno) != 0 THEN;
		DELETE FROM public."Board_RecommendedLogs" WHERE ContentNo = board_insertrecommendedlog.contentno AND UserNo = board_insertrecommendedlog.userno;
		UPDATE Board_Contents SET RecommendedCount = RecommendedCount -1 WHERE ContentNo = board_insertrecommendedlog.contentno
		RETURN QUERY
		SELECT CONVERT(BIGINT, 0);
		END IF;
	ELSE
	
	UPDATE Board_Contents SET RecommendedCount = RecommendedCount + 1 WHERE ContentNo = board_insertrecommendedlog.contentno

	INSERT INTO Board_RecommendedLogs (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
		DepartNo, DepartName, RecommendedDate)
	VALUES (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
		DepartNo, DepartName, RecommendedDate)
		

	LogNo := lastval();
	RETURN QUERY
	SELECT LogNo;
	 END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
