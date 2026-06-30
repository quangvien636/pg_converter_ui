-- ─── FUNCTION: work_getfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getfile(bigint);
CREATE OR REPLACE FUNCTION public.work_getfile(
    fileno bigint
) RETURNS TABLE(
    fileno bigserial,
    historyno integer,
    name character varying(260),
    length integer
)
AS $function$
BEGIN


	RETURN QUERY
	select * from WorkFiles where FileNo = work_getfile.fileno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
