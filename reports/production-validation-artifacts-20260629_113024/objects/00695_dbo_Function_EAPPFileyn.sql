-- ─── FUNCTION: eappfileyn ───────────────────────────────
DROP FUNCTION IF EXISTS public.eappfileyn(integer);
CREATE OR REPLACE FUNCTION public.eappfileyn(
    documentid integer
) RETURNS character varying
AS $function$
DECLARE
    fileyn character varying;
BEGIN
    


 RETURN (fileyn);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
