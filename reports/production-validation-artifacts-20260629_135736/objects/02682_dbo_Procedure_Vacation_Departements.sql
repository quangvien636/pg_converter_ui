-- ─── PROCEDURE→FUNCTION: vacation_departements ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.vacation_departements(character varying, character varying);
CREATE OR REPLACE FUNCTION public.vacation_departements(
    IN p_id character varying DEFAULT '',
    IN p_lang character varying DEFAULT 'KO'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



				RETURN QUERY
				SELECT 
					  d.DepartNo
					  , CAST(d.DepartNo as nvarchar) as id
					  ,d.Name as text
				FROM   Organization_Departments d
				where ',' || p_id || ',' ILIKE '%,' || CONVERT(VARCHAR(50),d.DepartNo)+',%';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
