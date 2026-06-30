-- ─── FUNCTION: eappgetreceivedepartuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappgetreceivedepartuser(integer);
CREATE OR REPLACE FUNCTION public.eappgetreceivedepartuser(
    documentid integer
) RETURNS character varying
AS $function$
DECLARE
    departuser character varying;
BEGIN




	return COALESCE(DepartUser,'');
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
