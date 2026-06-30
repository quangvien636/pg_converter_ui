-- ─── FUNCTION: organization_getdepartment ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartment(integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartment(
    departno integer
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
    name_vn text,
    sendername text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
	,Name_CH,Name_JP,Name_VN,SenderName
	FROM Organization_Departments
	WHERE DepartNo = organization_getdepartment.departno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
