-- ─── FUNCTION: drive_getpemissioncommonfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getpemissioncommonfolders(bigint);
CREATE OR REPLACE FUNCTION public.drive_getpemissioncommonfolders(
    p_no bigint
) RETURNS TABLE(
    sharingno text,
    folderno text,
    userno text,
    departno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT SharingNo, FolderNo, UserNo, DepartNo
	FROM Drive_PemissionCommonFolders
	WHERE FolderNo = drive_getpemissioncommonfolders.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
