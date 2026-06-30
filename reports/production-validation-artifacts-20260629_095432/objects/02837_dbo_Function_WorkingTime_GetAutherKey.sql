-- ─── FUNCTION: workingtime_getautherkey ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getautherkey();
CREATE OR REPLACE FUNCTION public.workingtime_getautherkey(
) RETURNS TABLE(
    authno serial,
    value character varying(100),
    statusi integer
)
AS $function$
BEGIN


	RETURN QUERY
	select * from WorkingTime_AutherKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
