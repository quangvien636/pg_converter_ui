-- ─── FUNCTION: organization_getinfoaddfield_sub ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getinfoaddfield_sub(integer);
CREATE OR REPLACE FUNCTION public.organization_getinfoaddfield_sub(
    no integer
) RETURNS TABLE(
    nosub serial,
    userno integer,
    no integer,
    regdate timestamp without time zone,
    moduserno integer,
    moddate timestamp without time zone,
    code character varying(100),
    name character varying(100),
    sortno integer,
    enabled boolean
)
AS $function$
BEGIN


	RETURN QUERY
	select * from Organization_Users_InfoAddfield_Sub where No = organization_getinfoaddfield_sub.no Order by SortNo asc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
