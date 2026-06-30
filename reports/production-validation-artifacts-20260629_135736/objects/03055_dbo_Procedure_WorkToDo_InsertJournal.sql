-- ─── PROCEDURE→FUNCTION: worktodo_insertjournal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_insertjournal(bigint, integer, timestamp without time zone, timestamp without time zone, integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.worktodo_insertjournal(
    IN datano bigint,
    IN moduserno integer,
    IN moddate timestamp without time zone,
    IN writedate timestamp without time zone,
    IN progressrate integer,
    IN worktime integer,
    IN content character varying,
    IN typeno integer
) RETURNS SETOF record
AS $function$
DECLARE
    journalno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkToDo_Journals (DataNo, ModUserNo, ModDate, WriteDate, ProgressRate, WorkTime, Content, TypeNo)
	VALUES (DataNo, ModUserNo, ModDate, WriteDate, ProgressRate, WorkTime, Content, TypeNo)
		

	JournalNo := lastval();;
	UPDATE WorkToDo_ToDoList SET ProgressRate = worktodo_insertjournal.progressrate, LatestJournalDate = worktodo_insertjournal.moddate
	WHERE DataNo = worktodo_insertjournal.datano
	
	RETURN QUERY
	SELECT JournalNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
