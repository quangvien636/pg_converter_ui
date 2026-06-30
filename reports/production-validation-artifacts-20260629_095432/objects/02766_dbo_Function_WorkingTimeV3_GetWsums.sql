-- ─── FUNCTION: workingtimev3_getwsums ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_getwsums(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtimev3_getwsums(
    p_fr integer,
    p_to integer
) RETURNS TABLE(
    over text,
    col2 text,
    userno text
)
AS $function$
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
