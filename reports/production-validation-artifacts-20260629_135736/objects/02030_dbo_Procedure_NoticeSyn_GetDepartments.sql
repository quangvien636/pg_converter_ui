-- ─── PROCEDURE→FUNCTION: noticesyn_getdepartments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getdepartments();
CREATE OR REPLACE FUNCTION public.noticesyn_getdepartments(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

RETURN QUERY
select DepartNo,ParentNo,(case when LangCode='EN' then Name_EN when LangCode='CH' then Name_CH when LangCode='JP' then Name_JP when LangCode='VN' then Name_VN else Name end) as Name
 from Organization_Departments where Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
