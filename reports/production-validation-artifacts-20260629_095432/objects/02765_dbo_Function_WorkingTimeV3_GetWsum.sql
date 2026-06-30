-- ─── FUNCTION: workingtimev3_getwsum ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_getwsum(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getwsum(
    p_uno integer,
    p_fr integer,
    p_to integer
) RETURNS TABLE(
    over text,
    col2 text
)
AS $function$
BEGIN


 RETURN QUERY
 SELECT 
   100 as over
 ,  COALESCE(SUM(CASE WHEN CX.status = 1 THEN CX.TimeWork ELSE 0 END),0) working
 FROM WorkingTime_Calculater CX
 WHERE WorkingDay  BETWEEN p_fr AND p_To and cx.UserNo = workingtimev3_getwsum.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
