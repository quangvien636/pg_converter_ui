-- ─── PROCEDURE→FUNCTION: workingtimev3_getwsums ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtimev3_getwsums(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getwsums(
    IN p_fr integer,
    IN p_to integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 RETURN QUERY
 SELECT 
   100 as over
 ,  COALESCE(SUM(CASE WHEN CX.status = 1 THEN CX.TimeWork ELSE 0 END),0) working
 , cx.UserNo
 FROM WorkingTime_Calculater CX
 WHERE WorkingDay  BETWEEN p_fr AND p_To 
 group by cx.UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
