-- ─── FUNCTION: drive_deletefoldertrash ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletefoldertrash(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletefoldertrash(
    p_fno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_Trash WHERE FolderNo = drive_deletefoldertrash.p_fno;
	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
