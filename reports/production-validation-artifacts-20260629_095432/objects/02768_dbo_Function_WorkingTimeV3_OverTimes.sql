-- ─── FUNCTION: workingtimev3_overtimes ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtimev3_overtimes(timestamp without time zone, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.workingtimev3_overtimes(
    p_fr timestamp without time zone,
    p_to timestamp without time zone
) RETURNS TABLE(
    col1 text,
    userno text
)
AS $function$
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
