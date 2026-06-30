-- ─── FUNCTION: workingtime_getsetuppage ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsetuppage();
CREATE OR REPLACE FUNCTION public.workingtime_getsetuppage(
) RETURNS TABLE(
    id serial,
    ispage integer,
    hidetime integer
)
AS $function$
BEGIN


	RETURN QUERY
	select * from WorkingTime_setupPages;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
