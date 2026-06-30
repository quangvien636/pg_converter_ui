-- ─── FUNCTION: workingtime_getallowdevices2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getallowdevices2();
CREATE OR REPLACE FUNCTION public.workingtime_getallowdevices2(
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT w.* FROM WorkingTime_AllowDevices w;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
