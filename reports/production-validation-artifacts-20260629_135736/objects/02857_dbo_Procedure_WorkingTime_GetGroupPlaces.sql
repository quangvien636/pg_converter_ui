-- ─── PROCEDURE→FUNCTION: workingtime_getgroupplaces ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getgroupplaces(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getgroupplaces(
    IN p_type integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


RETURN QUERY
select g.* , u.Name, u.Name_EN
from WorkingTime_GroupPlace g
left join Organization_Users u on g.RegUserNo = u.UserNo
where g.GType = workingtime_getgroupplaces.p_type;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
