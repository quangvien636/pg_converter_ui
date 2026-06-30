-- ─── PROCEDURE→FUNCTION: workingtime_deparandusers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_deparandusers(character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.workingtime_deparandusers(
    IN p_uids character varying DEFAULT '',
    IN p_dids character varying DEFAULT '',
    IN p_lang character varying DEFAULT 'KO'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

		RETURN QUERY
		SELECT 
				u.UserNo as iid
				, CAST(u.UserNo as varchar) as id
				,u.Name 
				,'user' as ltype
		FROM   Organization_Users u
		where ',' || p_uids || ',' ILIKE '%,' || CONVERT(VARCHAR(50),u.UserNo)+',%'
		union all
		RETURN QUERY
		SELECT 
				d.DepartNo as iid
				, CAST(d.DepartNo as varchar) as id
				,d.Name 
				,'depart' as ltype
		FROM   Organization_Departments d
		where ',' || p_dids || ',' ILIKE '%,' || CONVERT(VARCHAR(50),d.DepartNo)+',%';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
