-- ─── PROCEDURE→FUNCTION: work_getworkassistants ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getworkassistants(integer);
CREATE OR REPLACE FUNCTION public.work_getworkassistants(
    IN historyno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT HistoryNo, W.UserNo, U.UserID, U.Name AS UserName,
		P.Name AS PositionName, D.Name AS DepartName
	FROM WorkAssistants W
	LEFT JOIN Organization_Users U ON U.UserNo = W.UserNo
	LEFT JOIN Organization_BelongToDepartment B ON B.UserNo = W.UserNo
	LEFT JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE W.HistoryNo = work_getworkassistants.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
