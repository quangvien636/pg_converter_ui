-- ─── FUNCTION: schedule_getgoogle ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getgoogle(integer);
CREATE OR REPLACE FUNCTION public.schedule_getgoogle(
    p_uno integer
) RETURNS TABLE(
    uno integer,
    gdata integer
)
AS $function$
BEGIN

 RETURN QUERY
 select * from Schedule_CancelGoogle 
	where UNo = schedule_getgoogle.p_uno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
