-- ─── FUNCTION: gethqusers ───────────────────────────────
DROP FUNCTION IF EXISTS public.gethqusers(integer);
CREATE OR REPLACE FUNCTION public.gethqusers(
    userno integer
) RETURNS TABLE(
    workplacetype text
)
AS $function$
BEGIN


RETURN QUERY
select WorkPlaceType from Organization_Users where UserNo=gethqusers.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
