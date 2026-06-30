-- ─── FUNCTION: drive_deletetrash ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletetrash(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletetrash(
    itemno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_Trash WHERE ItemNo = drive_deletetrash.itemno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
