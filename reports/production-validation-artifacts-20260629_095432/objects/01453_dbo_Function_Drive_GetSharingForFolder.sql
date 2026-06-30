-- ─── FUNCTION: drive_getsharingforfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getsharingforfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getsharingforfolder(
    folderno bigint
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
	FROM Drive_SharingForFolders
	WHERE FolderNo = drive_getsharingforfolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
