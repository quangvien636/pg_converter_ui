-- ─── FUNCTION: workingtime_acceptcalculater ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_acceptcalculater(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_acceptcalculater(
    p_wkday integer,
    p_regno integer,
    p_type integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Calculater
	SET Status = workingtime_acceptcalculater.p_type
	WHERE WorkingDay=workingtime_acceptcalculater.p_wkday and UserNo = workingtime_acceptcalculater.p_regno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
