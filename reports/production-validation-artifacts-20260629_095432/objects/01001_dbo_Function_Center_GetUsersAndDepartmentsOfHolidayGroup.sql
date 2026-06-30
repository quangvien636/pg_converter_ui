-- ─── FUNCTION: center_getusersanddepartmentsofholidaygroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_getusersanddepartmentsofholidaygroup(integer);
CREATE OR REPLACE FUNCTION public.center_getusersanddepartmentsofholidaygroup(
    groupno integer
) RETURNS TABLE(
    departno text,
    name text,
    name_en text
)
AS $function$
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
