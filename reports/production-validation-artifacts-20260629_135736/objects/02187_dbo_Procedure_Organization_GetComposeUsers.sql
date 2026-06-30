-- ─── PROCEDURE→FUNCTION: organization_getcomposeusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getcomposeusers(integer);
CREATE OR REPLACE FUNCTION public.organization_getcomposeusers(
    IN departno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT B.UserNo, U.UserID, U.Name AS UserName,
		P.PositionNo, P.Name AS PositionName, P.SortNo AS PositionSortNo,
		D.DepartNo, D.Name AS DepartName
	FROM Organization_BelongToDepartment B
	INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
	INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
	INNER JOIN Organization_Departments D ON D.DepartNo = B.DepartNo
	WHERE B.DepartNo = organization_getcomposeusers.departno AND U.Enabled = TRUE
	ORDER BY P.SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
