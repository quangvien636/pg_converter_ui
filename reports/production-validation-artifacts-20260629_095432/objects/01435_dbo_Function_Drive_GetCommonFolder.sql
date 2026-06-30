-- ─── FUNCTION: drive_getcommonfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getcommonfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getcommonfolder(
    commonno bigint
) RETURNS TABLE(
    commonno text,
    maxlength text,
    folderno text,
    datecreated text,
    datemodified text,
    name text,
    length text,
    parentno text,
    isdeleted text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CF.CommonNo, CF.MaxLength, CF.FolderNo, F.DateCreated, F.DateModified, F.Name, F.Length, F.ParentNo, F.IsDeleted
	FROM Drive_CommonFolders CF
	INNER JOIN Drive_Folders F ON F.FolderNo = CF.FolderNo
	WHERE CF.CommonNo = drive_getcommonfolder.commonno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
