-- ─── PROCEDURE→FUNCTION: workingtimev3_getsumvacation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtimev3_getsumvacation(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getsumvacation(
    IN p_uno integer,
    IN p_y integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


 RETURN QUERY
 SELECT 
   U.UserNo
 , U.UserID
 , U.Name
 , COALESCE(x2.Addition1,0) + COALESCE(x2.Addition2,0) + COALESCE(V.Vacations,0) as TotalVacations -- To tal vacation
 , COALESCE(V.Vacations,0)  AS Vacations --- initial basic vacation 
 , COALESCE(x2.Addition1,0) Addition1-- addition basic vacation 
 , COALESCE(X2.Addition2,0) as Addition2 -- addition special vacation 
 , COALESCE(x3.Used1,0) + COALESCE(V.USED,0) as  Used1 --used basic vacation
 , COALESCE(x3.Used2,0) Used2 -- used special vacation
 FROM   Organization_Users U  
 LEFT JOIN Vacation_Vacations V ON V.UserNo =  U.UserNo AND (V.years = workingtimev3_getsumvacation.p_y)
 LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  workingtimev3_getsumvacation.p_y
 LEFT JOIN Vacation_SumRequest X3 ON u.UserNo =  X3.UserNo and x3.years = workingtimev3_getsumvacation.p_y
 where u.UserNo = workingtimev3_getsumvacation.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
