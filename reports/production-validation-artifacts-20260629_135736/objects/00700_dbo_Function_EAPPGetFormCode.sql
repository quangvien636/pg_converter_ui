-- ─── FUNCTION: eappgetformcode ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetformcode(integer);
CREATE OR REPLACE FUNCTION public.eappgetformcode(
    formid integer
) RETURNS character varying
AS $function$
DECLARE
    code character varying;
BEGIN






	RETURN	(Code);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
