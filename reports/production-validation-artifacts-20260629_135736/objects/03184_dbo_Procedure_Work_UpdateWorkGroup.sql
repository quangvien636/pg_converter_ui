-- ─── PROCEDURE→FUNCTION: work_updateworkgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_updateworkgroup(integer, integer, timestamp without time zone, character varying, integer, character varying, date, date);
CREATE OR REPLACE FUNCTION public.work_updateworkgroup(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN userno integer,
    IN content character varying,
    IN completedate date,
    IN startdate date
) RETURNS SETOF record
AS $function$
DECLARE
    historyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name, UserNo, Content, CompleteDate,StartDate)
	VALUES(ModUserNo, ModDate, GroupNo, Name, UserNo, Content, CompleteDate,StartDate)
	

	HistoryNo := lastval();;
	UPDATE WorkGroups SET
		ModUserNo = work_updateworkgroup.moduserno,
		ModDate = work_updateworkgroup.moddate,
		HistoryNo = HistoryNo
	WHERE GroupNo = work_updateworkgroup.groupno
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
