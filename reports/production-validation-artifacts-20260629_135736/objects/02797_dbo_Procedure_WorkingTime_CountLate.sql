-- ─── PROCEDURE→FUNCTION: workingtime_countlate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_countlate(integer);
CREATE OR REPLACE FUNCTION public.workingtime_countlate(
    IN p_wkd integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	
RETURN QUERY
Select COALESCE(	Sum( CASE WHEN (t.CheckTimeC >  (cast(LEFT(t.StarWorking,2) as int)*60+ cast(SUBSTRING(t.StarWorking,3,2) as int))) AND t.TimeType = 1 THEN 1 ELSE 0 END),0 )as Late

from WorkingTime_Times t where t.WorkingdayC = workingtime_countlate.p_wkd;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
