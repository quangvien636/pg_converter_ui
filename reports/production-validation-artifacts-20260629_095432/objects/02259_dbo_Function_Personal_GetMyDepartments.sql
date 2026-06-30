-- ─── FUNCTION: personal_getmydepartments ───────────────────────────────
DROP FUNCTION IF EXISTS public.personal_getmydepartments();
CREATE OR REPLACE FUNCTION public.personal_getmydepartments(
) RETURNS TABLE(
    userno text,
    seq text,
    departno text,
    departname text,
    positionno text,
    positionname text,
    dutyno text,
    dutyname text,
    isdefault text
)
AS $function$
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
