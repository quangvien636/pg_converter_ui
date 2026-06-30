-- ─── FUNCTION: workingtimev3_getsumvacations ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_getsumvacations(integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getsumvacations(
    p_y integer
) RETURNS TABLE(
    userno text,
    userid text,
    name text,
    col4 text,
    col5 text,
    col6 text,
    col7 text,
    col8 text,
    col9 text
)
AS $function$
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
 LEFT JOIN Vacation_Vacations V ON V.UserNo =  U.UserNo AND (V.years = workingtimev3_getsumvacations.p_y)
 LEFT JOIN Vacation_Sum X2 ON u.UserNo =  x2.UsernoI AND X2.YEARS =  workingtimev3_getsumvacations.p_y
 LEFT JOIN Vacation_SumRequest X3 ON u.UserNo =  X3.UserNo and x3.years = workingtimev3_getsumvacations.p_y;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
