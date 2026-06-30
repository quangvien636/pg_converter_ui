-- ─── FUNCTION: drive_getsharingforcommonfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getsharingforcommonfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getsharingforcommonfolder(
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
	FROM Drive_SharingForCommonFolders
	WHERE FolderNo = drive_getsharingforcommonfolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
