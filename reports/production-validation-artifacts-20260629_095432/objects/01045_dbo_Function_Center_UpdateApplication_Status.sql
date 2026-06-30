-- ─── FUNCTION: center_updateapplication_status ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateapplication_status(integer, integer);
CREATE OR REPLACE FUNCTION public.center_updateapplication_status(
    applicationno integer,
    status integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_Applications SET
		Status = center_updateapplication_status.status
	WHERE ApplicationNo = center_updateapplication_status.applicationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
