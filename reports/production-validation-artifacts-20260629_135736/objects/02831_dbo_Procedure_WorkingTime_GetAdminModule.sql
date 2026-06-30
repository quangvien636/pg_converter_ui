-- ─── PROCEDURE→FUNCTION: workingtime_getadminmodule ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getadminmodule();
CREATE OR REPLACE FUNCTION public.workingtime_getadminmodule(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
RETURN QUERY
select m.UserNo 
from Authority_ModulePermission m 
join Center_Applications c on m.ApplicationNo = c.ApplicationNo
where c.projectCode = 'WorkingTime'
union 
RETURN QUERY
select UserNo from Authority_SitePermissions;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
