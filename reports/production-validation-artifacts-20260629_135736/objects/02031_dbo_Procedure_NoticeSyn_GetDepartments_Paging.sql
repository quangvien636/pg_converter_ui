-- ─── PROCEDURE→FUNCTION: noticesyn_getdepartments_paging ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getdepartments_paging(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getdepartments_paging(
    IN langcode character varying,
    IN currentpageindex integer,
    IN viewcount integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
