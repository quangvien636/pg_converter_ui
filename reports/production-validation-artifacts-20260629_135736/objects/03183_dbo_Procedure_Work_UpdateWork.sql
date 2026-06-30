-- ─── PROCEDURE→FUNCTION: work_updatework ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_updatework(integer, integer, timestamp without time zone, integer, character varying, integer, integer, integer, date, boolean);
CREATE OR REPLACE FUNCTION public.work_updatework(
    IN workno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
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
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkHistorys(RegUserNo, RegDate, WorkNo, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	VALUES(ModUserNo, ModDate, WorkNo, Title, UserNo, DivisionNo,
		WorkTime, CompleteDate, IsEveryPerson, Content)
	

	HistoryNo := lastval();;
	UPDATE Works SET
		ModUserNo = work_updatework.moduserno,
		ModDate = work_updatework.moddate,
		GroupNo = work_updatework.groupno,
		HistoryNo = HistoryNo
	WHERE WorkNo = work_updatework.workno
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
