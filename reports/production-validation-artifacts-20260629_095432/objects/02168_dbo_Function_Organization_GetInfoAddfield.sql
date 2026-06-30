-- ─── FUNCTION: organization_getinfoaddfield ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getinfoaddfield();
CREATE OR REPLACE FUNCTION public.organization_getinfoaddfield(
) RETURNS TABLE(
    no serial,
    userno integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    code character varying(100),
    name character varying(100),
    type integer,
    sortno integer,
    modauth boolean,
    enabled boolean,
    display boolean
)
AS $function$
BEGIN



	RETURN QUERY
	select * from Organization_Users_InfoAddfield Order by SortNo asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
