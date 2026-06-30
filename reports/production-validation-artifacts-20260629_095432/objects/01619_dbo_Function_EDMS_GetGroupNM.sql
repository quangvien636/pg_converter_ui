-- ─── FUNCTION: edms_getgroupnm ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getgroupnm(character varying, integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.edms_getgroupnm(
    langcode character varying,
    userno integer,
    parentno integer,
    groupnm character varying
) RETURNS TABLE(
    col1 text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    departno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	RETURN QUERY
	select /* TOP 1 */ DepartNo=DepartNo from public."Organization_GetDepartmentsByUser"(UserNo) order by DepartNo ASC
	select GroupNM =( case when LangCode='EN' THEN Name_EN ELSE Name END) from Organization_Departments
where ParentNo=edms_getgroupnm.parentno and Enabled = TRUE and DepartNo=DepartNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
