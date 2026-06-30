-- ─── PROCEDURE→FUNCTION: center_getexclusionusersforotp ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getexclusionusersforotp();
CREATE OR REPLACE FUNCTION public.center_getexclusionusersforotp(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ExclusionNo, E.UserNo, E.DepartNo, StartDate, EndDate, Allow, E.SortNo,
		COALESCE(U.Name, '') AS UserName, COALESCE(U.Name_EN, '') AS UserName_EN,
		COALESCE(D.Name, '') AS DepartName, COALESCE(D.Name_EN, '') AS DepartName_EN
	FROM Center_ExclusionUsersForOTP E
	LEFT JOIN Organization_Users U ON U.UserNo = E.UserNo
	LEFT JOIN Organization_Departments D ON D.DepartNo = E.DepartNo
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
