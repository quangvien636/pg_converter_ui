-- ─── PROCEDURE→FUNCTION: worktodo_gettodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.worktodo_gettodo(bigint);
CREATE OR REPLACE FUNCTION public.worktodo_gettodo(
    IN datano bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
	RETURN QUERY
	SELECT DataNo, ToDoNo, ModUserNo, ModDate, Subject, Content, FileCount, TypeNo, GroupNo, RepNo,
	(select case LanguageSign when 'KO' then Name else  Name_EN end from Organization_Users where UserNo = RepNo) as RepName,
		StartDate, EndDate, ActualityEndDate, ProgressRate, Priority, State, StateModDate, Passed, LatestJournalDate
	FROM WorkToDo_ToDoList
	WHERE DataNo = worktodo_gettodo.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
