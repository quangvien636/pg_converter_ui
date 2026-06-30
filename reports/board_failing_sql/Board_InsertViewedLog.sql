-- ─── PROCEDURE→FUNCTION: board_insertviewedlog ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.board_insertviewedlog(integer, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.board_insertviewedlog(
    IN boardno integer DEFAULT 1,
    IN contentno bigint DEFAULT 5547,
    IN userno integer DEFAULT 70,
    IN username character varying DEFAULT 'Nguyen Ngo Giap',
    IN positionno integer DEFAULT 0,
    IN positionname character varying DEFAULT '',
    IN departno integer DEFAULT 0,
    IN departname character varying DEFAULT '관리부',
    IN vieweddate timestamp without time zone DEFAULT '2022-02-01 03:52:51.050',
    IN clientip character varying DEFAULT ':'
) RETURNS SETOF record
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Board_ViewedLogs WHERE ContentNo = board_insertviewedlog.contentno AND UserNo = board_insertviewedlog.userno) > 0 THEN
		SELECT LogNo INTO logno FROM Board_ViewedLogs WHERE ContentNo = board_insertviewedlog.contentno AND UserNo = board_insertviewedlog.userno
	ELSE
	BEGIN;
		UPDATE Board_Contents SET ViewedCount = ViewedCount + 1 WHERE ContentNo = board_insertviewedlog.contentno;
		INSERT INTO Board_ViewedLogs (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
			DepartNo, DepartName, ViewedDate, ClientIP)
		VALUES (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
			DepartNo, DepartName, ViewedDate, ClientIP);
		LogNo := (lastval());
	END;
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.