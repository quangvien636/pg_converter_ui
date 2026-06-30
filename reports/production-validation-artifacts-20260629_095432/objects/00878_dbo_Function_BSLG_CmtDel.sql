-- ─── FUNCTION: bslg_cmtdel ───────────────────────────────
DROP FUNCTION IF EXISTS public.bslg_cmtdel(integer);
CREATE OR REPLACE FUNCTION public.bslg_cmtdel(
    id integer
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_Comment
	
	WHERE ID = bslg_cmtdel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
