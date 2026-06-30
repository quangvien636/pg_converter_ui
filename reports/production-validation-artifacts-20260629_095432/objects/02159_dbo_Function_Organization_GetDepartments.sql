-- ─── FUNCTION: organization_getdepartments ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartments(boolean);
CREATE OR REPLACE FUNCTION public.organization_getdepartments(
    isdisabled boolean DEFAULT FALSE
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


	IF IsDisabled = TRUE BEGIN
	
		RETURN QUERY
		SELECT DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
                ,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments
		ORDER BY SortNo ASC
		
	END
	
	ELSE BEGIN
	
		RETURN QUERY
		SELECT DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
                ,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments
		WHERE Enabled = TRUE
		ORDER BY SortNo ASC
		
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
