-- ─── FUNCTION: noticesyn_getdepartments ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getdepartments();
CREATE OR REPLACE FUNCTION public.noticesyn_getdepartments(
) RETURNS TABLE(
    departno text,
    parentno text,
    name text
)
AS $function$
BEGIN

RETURN QUERY
select DepartNo,ParentNo,(case when LangCode='EN' then Name_EN when LangCode='CH' then Name_CH when LangCode='JP' then Name_JP when LangCode='VN' then Name_VN else Name end) as Name
 from Organization_Departments where Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
