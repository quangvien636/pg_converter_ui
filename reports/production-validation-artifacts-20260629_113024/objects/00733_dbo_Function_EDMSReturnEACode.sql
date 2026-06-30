-- ─── FUNCTION: edmsreturneacode ───────────────────────────────
DROP FUNCTION IF EXISTS public.edmsreturneacode(integer);
CREATE OR REPLACE FUNCTION public.edmsreturneacode(
    id integer
) RETURNS character varying
AS $function$
DECLARE
    eacode character varying;
BEGIN


	if eacode is null
	begin
		set eacode = ''
	end
	return eacode;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
