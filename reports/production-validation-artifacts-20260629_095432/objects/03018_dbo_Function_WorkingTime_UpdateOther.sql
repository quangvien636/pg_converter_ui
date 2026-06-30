-- ─── FUNCTION: workingtime_updateother ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_updateother(integer);
CREATE OR REPLACE FUNCTION public.workingtime_updateother(
    p_wkno integer
) RETURNS void
AS $function$
BEGIN

	UPDATE WorkingTime_Times 
	SET NameCompany = p_name
	WHERE WorkingNo = workingtime_updateother.p_wkno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
