-- ─── FUNCTION: edms_getdoctitle ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getdoctitle(integer);
CREATE OR REPLACE FUNCTION public.edms_getdoctitle(
    docid integer
) RETURNS TABLE(
    title text
)
AS $function$
BEGIN


RETURN QUERY
select title from EDMSDocument where id=edms_getdoctitle.docid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
