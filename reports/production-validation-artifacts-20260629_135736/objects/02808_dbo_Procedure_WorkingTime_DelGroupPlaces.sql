-- ─── PROCEDURE→FUNCTION: workingtime_delgroupplaces ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_delgroupplaces(integer);
CREATE OR REPLACE FUNCTION public.workingtime_delgroupplaces(
    IN p_gno integer
) RETURNS void
AS $function$
BEGIN


DELETE FROM WorkingTime_GroupPlace  where GNo = workingtime_delgroupplaces.p_gno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
