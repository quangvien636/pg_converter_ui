-- ─── FUNCTION: noticesyn_getdepartments_paging ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getdepartments_paging(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getdepartments_paging(
    langcode character varying,
    currentpageindex integer,
    viewcount integer
) RETURNS TABLE(
    total text,
    rownum text,
    departno text,
    parentno text,
    name text
)
AS $function$
BEGIN

RETURN QUERY
select * from (
select CONVERT(INT,COUNT(*) OVER()) AS Total, ROW_NUMBER() OVER (Order by DepartNo) AS RowNum, DepartNo,ParentNo,(case when LangCode='EN' then Name_EN when LangCode='CH' then Name_CH when LangCode='JP' then Name_JP when LangCode='VN' then Name_VN else Name end) as Name
 from Organization_Departments where Enabled = TRUE
 ) T
 where T.RowNum BETWEEN CONVERT(NVARCHAR(20), ((CurrentPageIndex - 1) * ViewCount) + 1) AND CONVERT(NVARCHAR(20), CurrentPageIndex * ViewCount);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
