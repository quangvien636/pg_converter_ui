-- ─── FUNCTION: center_updateipfilter ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateipfilter(integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_updateipfilter(
    filterno integer,
    clientip character varying,
    allow boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_IPFilters SET
		ClientIP = center_updateipfilter.clientip,
		Allow = center_updateipfilter.allow
	WHERE FilterNo = center_updateipfilter.filterno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
