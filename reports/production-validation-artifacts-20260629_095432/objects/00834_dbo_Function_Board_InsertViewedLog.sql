-- ─── FUNCTION: board_insertviewedlog ───────────────────────────────
DROP FUNCTION IF EXISTS public.board_insertviewedlog(integer, bigint, integer, character varying, integer, character varying, integer, character varying, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.board_insertviewedlog(
    boardno integer DEFAULT 1,
    contentno bigint DEFAULT 5547,
    userno integer DEFAULT 70,
    username character varying DEFAULT 'Nguyen Ngo Giap',
    positionno integer DEFAULT 0,
    positionname character varying DEFAULT '',
    departno integer DEFAULT 0,
    departname character varying DEFAULT '관리부',
    vieweddate timestamp without time zone DEFAULT '2022-02-01 03:52:51.050',
    clientip character varying DEFAULT ':'
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF (SELECT COUNT(*) FROM Board_ViewedLogs WHERE ContentNo = board_insertviewedlog.contentno AND UserNo = board_insertviewedlog.userno) > 0 
	BEGIN
		RETURN QUERY
		SELECT /* /* TOP 1 */ */ LogNo=LogNo  FROM Board_ViewedLogs WHERE ContentNo = board_insertviewedlog.contentno AND UserNo = board_insertviewedlog.userno
	END
	ELSE
	BEGIN;
		UPDATE Board_Contents SET ViewedCount = ViewedCount + 1 WHERE ContentNo = board_insertviewedlog.contentno;
		INSERT INTO Board_ViewedLogs (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
			DepartNo, DepartName, ViewedDate, ClientIP)
		VALUES (BoardNo, ContentNo, UserNo, UserName, PositionNo, PositionName,
			DepartNo, DepartName, ViewedDate, ClientIP)
		SELECT LogNo = lastval();
		
	END
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
