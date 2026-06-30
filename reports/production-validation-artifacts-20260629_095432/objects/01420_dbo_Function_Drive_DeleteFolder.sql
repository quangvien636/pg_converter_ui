-- ─── FUNCTION: drive_deletefolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletefolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletefolder(
    folderno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_Folders WHERE FolderNo = drive_deletefolder.folderno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
