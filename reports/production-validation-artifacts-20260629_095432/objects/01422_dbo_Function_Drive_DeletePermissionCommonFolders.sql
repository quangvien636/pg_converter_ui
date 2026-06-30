-- ─── FUNCTION: drive_deletepermissioncommonfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deletepermissioncommonfolders(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletepermissioncommonfolders(
    f_no bigint
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	DELETE FROM Drive_PemissionCommonFolders WHERE FolderNo = drive_deletepermissioncommonfolders.f_no

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
