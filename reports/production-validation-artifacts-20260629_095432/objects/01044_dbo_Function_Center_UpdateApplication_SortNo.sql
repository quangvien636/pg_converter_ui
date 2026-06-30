-- ─── FUNCTION: center_updateapplication_sortno ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_updateapplication_sortno(integer, integer);
CREATE OR REPLACE FUNCTION public.center_updateapplication_sortno(
    applicationno integer,
    sortno integer
) RETURNS void
AS $function$
BEGIN


	UPDATE Center_Applications SET
		SortNo = center_updateapplication_sortno.sortno
	WHERE ApplicationNo = center_updateapplication_sortno.applicationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
