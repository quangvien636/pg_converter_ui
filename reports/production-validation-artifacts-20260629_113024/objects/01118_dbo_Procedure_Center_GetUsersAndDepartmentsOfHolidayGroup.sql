-- ─── PROCEDURE→FUNCTION: center_getusersanddepartmentsofholidaygroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.center_getusersanddepartmentsofholidaygroup(integer);
CREATE OR REPLACE FUNCTION public.center_getusersanddepartmentsofholidaygroup(
    IN groupno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT U.UserNo, U.Name, U.Name_EN
	FROM Center_HolidayGroupOfUsers H
	INNER JOIN Organization_Users U ON U.UserNo = H.UserNo
	WHERE H.GroupNo = center_getusersanddepartmentsofholidaygroup.groupno

	RETURN QUERY
	SELECT D.DepartNo, D.Name, D.Name_EN
	FROM Center_HolidayGroupOfDepartments H
	INNER JOIN Organization_Departments D ON D.DepartNo = H.DepartNo
	WHERE H.GroupNo = center_getusersanddepartmentsofholidaygroup.groupno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
