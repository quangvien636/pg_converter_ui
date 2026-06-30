-- ─── FUNCTION: edms_getfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.edms_getfile(integer);
CREATE OR REPLACE FUNCTION public.edms_getfile(
    id integer
) RETURNS TABLE(
    id serial,
    docid integer,
    attachpath character varying(500),
    attachname character varying(250),
    attachflag character varying(10),
    ispdf character(1),
    contentid integer,
    length bigint
)
AS $function$
BEGIN


RETURN QUERY
select * from edmsfile where ID=edms_getfile.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
