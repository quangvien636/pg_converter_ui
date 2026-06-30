-- ─── PROCEDURE→FUNCTION: organization_getdepartments ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getdepartments(boolean);
CREATE OR REPLACE FUNCTION public.organization_getdepartments(
    IN isdisabled boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF IsDisabled = TRUE THEN
	
		RETURN QUERY
		SELECT DepartNo, ModUserNo, ModDate, ParentNo, Name, Name_EN, ShortName, SortNo, Enabled
                ,Name_CH,Name_JP,Name_VN
		FROM Organization_Departments
		ORDER BY SortNo ASC
		
	END IF;
	
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
