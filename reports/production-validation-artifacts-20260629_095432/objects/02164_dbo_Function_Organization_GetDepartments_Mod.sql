-- ─── FUNCTION: organization_getdepartments_mod ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartments_mod(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_getdepartments_mod(
    moddate timestamp without time zone
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
	SELECT DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
            ,Name_CH,Name_JP,Name_VN
	FROM Organization_Departments
	WHERE ModDate > organization_getdepartments_mod.moddate
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
