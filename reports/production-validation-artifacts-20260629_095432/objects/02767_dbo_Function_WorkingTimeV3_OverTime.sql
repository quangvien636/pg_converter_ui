-- ─── FUNCTION: workingtimev3_overtime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_overtime(integer, timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.workingtimev3_overtime(
    p_uno integer,
    p_fr timestamp without time zone,
    p_to timestamp without time zone
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


 RETURN QUERY
 SELECT 
   COALESCE(SUM(CX.Overtime),0) Overtime
 FROM WorkingTimeV3_Vacations CX
 WHERE cx.StartDate >= workingtimev3_overtime.p_fr  and  cx.EndDate <= workingtimev3_overtime.p_to 
 and cx.UserNo = workingtimev3_overtime.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
