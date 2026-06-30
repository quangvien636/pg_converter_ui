-- ─── PROCEDURE→FUNCTION: workingtimev3_overtimes ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtimev3_overtimes(timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.workingtimev3_overtimes(
    IN p_fr timestamp without time zone,
    IN p_to timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 RETURN QUERY
 SELECT 
   COALESCE(SUM(CX.Overtime),0) Overtime
 , cx.UserNo
 FROM WorkingTimeV3_Vacations CX
 WHERE cx.StartDate >= workingtimev3_overtimes.p_fr  and  cx.EndDate <= workingtimev3_overtimes.p_to 
 group by cx.UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
