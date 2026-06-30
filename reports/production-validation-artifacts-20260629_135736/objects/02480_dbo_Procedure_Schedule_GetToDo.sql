-- ─── PROCEDURE→FUNCTION: schedule_gettodo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_gettodo(integer);
CREATE OR REPLACE FUNCTION public.schedule_gettodo(
    IN todono integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ToDoNo, S.RegUserNo, public."COMNGetUserName"(S.RegUserNo) as RegUserName, S.RegDate, S.ModUserNo, S.ModDate, Title, S.GroupNo, DG.Name AS GroupName,
		S.Important, CompleteDate, IsComplete,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, ProgressRate
	FROM ScheduleToDos S
	LEFT JOIN ScheduleToDoGroups DG ON DG.GroupNo = S.GroupNo
	WHERE ToDoNo = schedule_gettodo.todono;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
