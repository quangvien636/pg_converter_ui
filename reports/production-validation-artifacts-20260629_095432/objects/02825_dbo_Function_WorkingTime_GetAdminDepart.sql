-- ─── FUNCTION: workingtime_getadmindepart ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getadmindepart();
CREATE OR REPLACE FUNCTION public.workingtime_getadmindepart(
) RETURNS TABLE(
    userno text
)
AS $function$
BEGIN


	
RETURN QUERY
select m.UserNo 
from WORKINGTIME_ALLOWDEVICES m 
where m.IsUserFull = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
