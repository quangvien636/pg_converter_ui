-- ─── FUNCTION: drive_deletecommonfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletecommonfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletecommonfolder(
    commonno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_CommonFolders WHERE CommonNo = drive_deletecommonfolder.commonno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
