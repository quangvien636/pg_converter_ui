-- ─── PROCEDURE→FUNCTION: work_updateregularworkgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_updateregularworkgroup(integer, integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_updateregularworkgroup(
    IN groupno integer,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN name character varying,
    IN divisionno integer,
    IN userno integer,
    IN iseveryperson boolean
) RETURNS SETOF record
AS $function$
DECLARE
    historyno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO RegularWorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name,
		DivisionNo, UserNo, IsEveryPerson, Content)
	VALUES(ModUserNo, ModDate, GroupNo, Name, DivisionNo, UserNo, IsEveryPerson, Content)
	

	HistoryNo := lastval();;
	UPDATE RegularWorkGroups SET
		ModUserNo = work_updateregularworkgroup.moduserno,
		ModDate = work_updateregularworkgroup.moddate,
		HistoryNo = HistoryNo
	WHERE GroupNo = work_updateregularworkgroup.groupno
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
