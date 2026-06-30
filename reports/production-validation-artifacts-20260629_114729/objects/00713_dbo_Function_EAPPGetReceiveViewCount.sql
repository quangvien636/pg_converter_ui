-- ─── FUNCTION: eappgetreceiveviewcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetreceiveviewcount(integer);
CREATE OR REPLACE FUNCTION public.eappgetreceiveviewcount(
    targetid integer
) RETURNS integer
AS $function$
DECLARE
    cnt integer;
BEGIN
	

	return cnt;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
