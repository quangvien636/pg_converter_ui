-- ─── FUNCTION: drive_deletesharingforfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletesharingforfolders(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletesharingforfolders(
    folderno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_SharingForFolders WHERE FolderNo = drive_deletesharingforfolders.folderno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
