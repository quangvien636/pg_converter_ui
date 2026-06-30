-- ─── FUNCTION: workingtime_updateischeckin ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateischeckin(integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateischeckin(
    p_no integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Calculater
	SET IsCheckIn = TRUE
	WHERE Calculaterno=workingtime_updateischeckin.p_no
END;


--EXEC WorkingTime_UpdateIsCheckIn 9262
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
