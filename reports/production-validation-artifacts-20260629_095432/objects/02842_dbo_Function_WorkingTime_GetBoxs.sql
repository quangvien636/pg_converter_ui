-- ─── FUNCTION: workingtime_getboxs ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getboxs();
CREATE OR REPLACE FUNCTION public.workingtime_getboxs(
) RETURNS TABLE(
    no serial,
    name character varying(200),
    sort double precision
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT *
	FROM WorkingTime_BoxUses
	order by Sort;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
