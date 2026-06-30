-- ─── PROCEDURE→FUNCTION: organization_getdepartments_mod ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getdepartments_mod(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.organization_getdepartments_mod(
    IN moddate timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
