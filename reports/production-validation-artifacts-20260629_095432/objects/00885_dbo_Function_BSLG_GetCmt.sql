-- ─── FUNCTION: bslg_getcmt ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_getcmt(integer);
CREATE OR REPLACE FUNCTION public.bslg_getcmt(
    pid integer
) RETURNS TABLE(
    content text
)
AS $function$
BEGIN
RETURN QUERY
select content from BSLG_comment where id=bslg_getcmt.pid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
