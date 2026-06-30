-- ─── PROCEDURE→FUNCTION: schedule_deletetodosall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_deletetodosall();
CREATE OR REPLACE FUNCTION public.schedule_deletetodosall(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	INSERT INTO ScheduleToDosHistory
	(
		ToDoNo,
		HistoryType,
		RegDate,
		RegUserNo
	)
	RETURN QUERY
	SELECT ToDoNo, 'D', NOW(), RegUserNo
	FROM ScheduleToDos
	WHERE RegUserNo = UserNo;
	
	DELETE FROM ScheduleToDos WHERE RegUserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
