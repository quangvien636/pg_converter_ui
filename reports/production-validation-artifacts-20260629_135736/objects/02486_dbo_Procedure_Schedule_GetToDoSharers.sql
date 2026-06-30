-- ─── PROCEDURE→FUNCTION: schedule_gettodosharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_gettodosharers();
CREATE OR REPLACE FUNCTION public.schedule_gettodosharers(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		S.ToDoNo, S.UserNo,
		COALESCE(U.UserID,'') As UserID, COALESCE(U.Name, '') As UserName,
		S.DepartNo, COALESCE(D.Name,'') As DepartName,
		S.PositionNo, COALESCE(P.Name,'') AS PositionName
	FROM ScheduleToDoSharers S
	LEFT JOIN Organization_Users U ON U.UserNo = S.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = S.DepartNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = S.PositionNo
	WHERE S.ToDoNo = ToDoNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
