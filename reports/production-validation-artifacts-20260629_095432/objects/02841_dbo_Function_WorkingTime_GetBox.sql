-- ─── FUNCTION: workingtime_getbox ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getbox(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getbox(
    p_no integer
) RETURNS TABLE(
    no serial,
    name character varying(200),
    sort double precision
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT *
	FROM WorkingTime_BoxUses B WHERE B.No = workingtime_getbox.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
