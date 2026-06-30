-- ─── PROCEDURE→FUNCTION: bslg_cmtedit ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_cmtedit(integer, character varying);
CREATE OR REPLACE FUNCTION public.bslg_cmtedit(
    IN pid integer,
    IN content character varying
) RETURNS void
AS $function$
BEGIN
update BSLG_comment set content=bslg_cmtedit.content where id=bslg_cmtedit.pid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
