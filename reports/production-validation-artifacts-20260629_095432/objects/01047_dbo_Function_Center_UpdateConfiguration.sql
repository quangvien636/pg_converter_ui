-- ─── FUNCTION: center_updateconfiguration ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateconfiguration(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_updateconfiguration(
    moduserno integer,
    moddate timestamp without time zone,
    key character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_Configuration SET
		ModUserNo = center_updateconfiguration.moduserno,
		ModDate = center_updateconfiguration.moddate,
		Value = Value
	WHERE Key = center_updateconfiguration.key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
