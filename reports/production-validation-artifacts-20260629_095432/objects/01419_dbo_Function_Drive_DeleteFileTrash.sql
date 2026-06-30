-- ─── FUNCTION: drive_deletefiletrash ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletefiletrash(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletefiletrash(
    p_fno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_Trash WHERE FileNo = drive_deletefiletrash.p_fno
	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
