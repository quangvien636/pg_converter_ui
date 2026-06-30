-- ─── FUNCTION: workingtime_getdepartmentsbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getdepartmentsbyuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getdepartmentsbyuser(
    userno integer
) RETURNS TABLE(
    departno text,
    moduserno text,
    moddate text,
    parentno text,
    name text,
    name_en text,
    shortname text,
    sortno text,
    enabled text,
    name_ch text,
    name_jp text,
    name_vn text
)
AS $function$
BEGIN


		RETURN QUERY
		SELECT O.DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
				,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments O
		INNER JOIN Organization_BelongToDepartment F
		ON O.DepartNo = F.DepartNo
		WHERE Enabled = TRUE And F.UserNo = workingtime_getdepartmentsbyuser.userno
		ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
