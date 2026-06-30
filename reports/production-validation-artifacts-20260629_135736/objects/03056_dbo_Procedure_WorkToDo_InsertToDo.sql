-- ─── PROCEDURE→FUNCTION: worktodo_inserttodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_inserttodo(bigint, timestamp without time zone, character varying, character varying, integer, integer, integer, bigint, timestamp without time zone, integer, integer, timestamp without time zone, boolean);
CREATE OR REPLACE FUNCTION public.worktodo_inserttodo(
    IN moduserno bigint,
    IN moddate timestamp without time zone,
    IN subject character varying,
    IN content character varying,
    IN filecount integer,
    IN typeno integer,
    IN groupno integer,
    IN repno bigint,
    IN enddate timestamp without time zone,
    IN priority integer,
    IN state integer,
    IN statemoddate timestamp without time zone,
    IN passed boolean
) RETURNS SETOF record
AS $function$
DECLARE
    todono integer;
    datano bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	ToDoNo := (SELECT COALESCE(MAX(ToDoNo), 0) + 1 FROM WorkToDo_ToDoList WHERE RepNo = worktodo_inserttodo.repno);;
	INSERT INTO WorkToDo_ToDoList (ToDoNo, ModUserNo, ModDate, Subject, Content, FileCount, TypeNo, GroupNo, RepNo,
		StartDate, EndDate, ActualityEndDate, ProgressRate, Priority, State, StateModDate, Passed, LatestJournalDate)
	VALUES (ToDoNo, ModUserNo, ModDate, Subject, Content, FileCount, TypeNo, GroupNo, RepNo,
		NOW(), EndDate, EndDate, 0, Priority, State, StateModDate, Passed, NOW())
		

	DataNo := lastval();
	RETURN QUERY
	SELECT DataNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
