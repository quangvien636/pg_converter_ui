-- ─── FUNCTION: center_updatecompanyinformation ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updatecompanyinformation(integer, timestamp without time zone, character varying);
CREATE OR REPLACE FUNCTION public.center_updatecompanyinformation(
    moduserno integer,
    moddate timestamp without time zone,
    key character varying
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_CompanyInformation SET
		ModUserNo = center_updatecompanyinformation.moduserno,
		ModDate = center_updatecompanyinformation.moddate,
		Value = Value
	WHERE Key = center_updatecompanyinformation.key;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
