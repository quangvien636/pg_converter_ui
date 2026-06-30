-- ─── PROCEDURE→FUNCTION: schedule_getchilddeparts ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getchilddeparts();
CREATE OR REPLACE FUNCTION public.schedule_getchilddeparts(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	WITH DEPT_CTE (DepartNo) AS 
	(
		SELECT DepartNo
		FROM Organization_Departments
		WHERE DepartNo = DepartNo
		AND Enabled = TRUE
		UNION ALL
		SELECT PD.DepartNo
		FROM Organization_Departments PD JOIN DEPT_CTE DC ON PD.ParentNo = DC.DepartNo
		AND PD.Enabled = TRUE
	)
	RETURN QUERY
	SELECT DepartNo
	FROM DEPT_CTE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
