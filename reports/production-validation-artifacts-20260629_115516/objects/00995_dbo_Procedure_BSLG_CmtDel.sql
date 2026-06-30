-- ─── PROCEDURE→FUNCTION: bslg_cmtdel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.bslg_cmtdel(integer);
CREATE OR REPLACE FUNCTION public.bslg_cmtdel(
    IN id integer
) RETURNS void
AS $function$
BEGIN
	DELETE FROM BSLG_Comment
	
	WHERE ID = bslg_cmtdel.id;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
