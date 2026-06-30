-- ─── FUNCTION: drive_deletesharingforcommonfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletesharingforcommonfolders(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletesharingforcommonfolders(
    folderno bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_SharingForCommonFolders WHERE FolderNo = drive_deletesharingforcommonfolders.folderno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
