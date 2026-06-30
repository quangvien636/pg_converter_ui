-- ─── PROCEDURE→FUNCTION: work_insertwork ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_insertwork(integer, timestamp without time zone, integer, character varying, integer, integer, integer, date, boolean);
CREATE OR REPLACE FUNCTION public.work_insertwork(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN groupno integer,
    IN title character varying,
    IN userno integer,
    IN divisionno integer,
    IN worktime integer,
    IN completedate date,
    IN iseveryperson boolean
) RETURNS SETOF record
AS $function$
DECLARE
    historyno integer;
    workno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkHistorys(RegUserNo, RegDate, WorkNo, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	VALUES(RegUserNo, RegDate, 0, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	

	HistoryNo := lastval();;
	INSERT INTO Works(RegUserNo, RegDate, ModUserNo, ModDate, GroupNo, HistoryNo, CompletionRate, Enabled)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, GroupNo, HistoryNo, 0, 1)
	

	WorkNo := lastval();;
	UPDATE WorkHistorys SET WorkNo = WorkNo
	WHERE HistoryNo = HistoryNo
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
