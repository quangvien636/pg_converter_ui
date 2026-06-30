-- ─── FUNCTION: workingtime_acceptoutcalculater ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_acceptoutcalculater(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_acceptoutcalculater(
    p_wkday integer,
    p_regno integer,
    p_type integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Calculater
	SET StatusOut = workingtime_acceptoutcalculater.p_type
	WHERE WorkingDay=workingtime_acceptoutcalculater.p_wkday and UserNo = workingtime_acceptoutcalculater.p_regno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
