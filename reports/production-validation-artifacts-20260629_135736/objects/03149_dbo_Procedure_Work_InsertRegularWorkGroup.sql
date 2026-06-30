-- ─── PROCEDURE→FUNCTION: work_insertregularworkgroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_insertregularworkgroup(integer, timestamp without time zone, character varying, integer, integer, boolean);
CREATE OR REPLACE FUNCTION public.work_insertregularworkgroup(
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN name character varying,
    IN divisionno integer,
    IN userno integer,
    IN iseveryperson boolean
) RETURNS SETOF record
AS $function$
DECLARE
    historyno integer;
    groupno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO RegularWorkGroupHistorys(RegUserNo, RegDate, GroupNo, Name,
		DivisionNo, UserNo, IsEveryPerson, Content)
	VALUES(RegUserNo, RegDate, 0, Name, DivisionNo, UserNo, IsEveryPerson, Content)
	

	HistoryNo := lastval();;
	INSERT INTO RegularWorkGroups(RegUserNo, RegDate, ModUserNo, ModDate, HistoryNo, Enabled)
	VALUES(RegUserNo, RegDate, RegUserNo, RegDate, HistoryNo, 1)
	

	GroupNo := lastval();;
	UPDATE RegularWorkGroupHistorys SET GroupNo = GroupNo
	WHERE HistoryNo = HistoryNo
	
	RETURN QUERY
	SELECT HistoryNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
