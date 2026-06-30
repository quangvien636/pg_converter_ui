-- ─── PROCEDURE→FUNCTION: work_insertworkgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_insertworkgroup(integer, timestamp without time zone, character varying, integer, character varying, date, date, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkgroup(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN name character varying,
    IN userno integer,
    IN content character varying,
    IN completedate date,
    IN startdate date,
    IN state integer
) RETURNS SETOF record
AS $function$
DECLARE
    historyno integer;
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name, UserNo, Content, CompleteDate, StartDate)
	VALUES(RegUserNo, RegDate, 0, Name, UserNo, Content, CompleteDate,StartDate)
	

	HistoryNo := lastval();;
	INSERT INTO WorkGroups(RegUserNo, RegDate, ModUserNo, ModDate, HistoryNo,
		IsLock, State, Enabled)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, HistoryNo, 0, State, 1)
	

	GroupNo := lastval();;
	UPDATE WorkGroupHistorys SET GroupNo = GroupNo
	WHERE HistoryNo = HistoryNo
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
