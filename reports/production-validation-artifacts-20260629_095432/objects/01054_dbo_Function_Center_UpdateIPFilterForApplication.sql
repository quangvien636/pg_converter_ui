-- ─── FUNCTION: center_updateipfilterforapplication ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateipfilterforapplication(integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.center_updateipfilterforapplication(
    filterno integer,
    clientip character varying,
    allow boolean
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_IPFiltersForApplication SET
		ClientIP = center_updateipfilterforapplication.clientip,
		Allow = center_updateipfilterforapplication.allow
	WHERE FilterNo = center_updateipfilterforapplication.filterno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
