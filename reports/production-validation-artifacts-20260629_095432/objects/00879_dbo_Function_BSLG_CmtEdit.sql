-- ─── FUNCTION: bslg_cmtedit ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_cmtedit(integer, character varying);
CREATE OR REPLACE FUNCTION public.bslg_cmtedit(
    pid integer,
    content character varying
) RETURNS void
AS $function$
BEGIN
update BSLG_comment set content=bslg_cmtedit.content where id=bslg_cmtedit.pid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
