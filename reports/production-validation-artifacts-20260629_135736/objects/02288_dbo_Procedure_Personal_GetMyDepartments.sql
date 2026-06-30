-- ─── PROCEDURE→FUNCTION: personal_getmydepartments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.personal_getmydepartments();
CREATE OR REPLACE FUNCTION public.personal_getmydepartments(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		BD.UserNo, 
		BD.Seq, 
		BD.DepartNo, 
		D.Name AS DepartName,
		BD.PositionNo, 
		P.Name AS PositionName,
		BD.DutyNo,
		T.Name AS DutyName,
		BD.IsDefault
	FROM BelongToDepartment BD
	LEFT JOIN Departments D ON D.DepartNo = BD.DepartNo
	LEFT JOIN Positions P ON P.PositionNo = BD.PositionNo
	LEFT JOIN Duties T ON T.DutyNo = BD.DutyNo
	WHERE UserNo = UserNo
	ORDER BY IsDefault DESC, Seq;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
