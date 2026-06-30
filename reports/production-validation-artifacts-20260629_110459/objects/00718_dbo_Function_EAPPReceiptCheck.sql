-- ─── FUNCTION: eappreceiptcheck ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappreceiptcheck(integer);
CREATE OR REPLACE FUNCTION public.eappreceiptcheck(
    docid integer
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
