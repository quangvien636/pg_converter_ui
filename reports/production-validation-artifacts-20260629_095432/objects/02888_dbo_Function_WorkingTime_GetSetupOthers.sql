-- ─── FUNCTION: workingtime_getsetupothers ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsetupothers();
CREATE OR REPLACE FUNCTION public.workingtime_getsetupothers(
) RETURNS TABLE(
    no integer,
    value1 integer,
    value2 integer,
    value3 integer,
    value4 integer,
    value5 integer,
    value6 integer,
    value7 integer,
    value8 integer,
    value9 integer,
    value10 integer,
    value11 integer,
    value12 integer,
    value13 integer,
    value14 integer
)
AS $function$
BEGIN


	RETURN QUERY
	select * from WorkingTime_SetupOther;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
