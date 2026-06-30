-- ─── FUNCTION: drive_getalltopcommonfolders ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getalltopcommonfolders();
CREATE OR REPLACE FUNCTION public.drive_getalltopcommonfolders(
) RETURNS TABLE(
    commonno text,
    maxlength text,
    folderno text,
    datecreated text,
    datemodified text,
    name text,
    col7 text,
    parentno text,
    isdeleted text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT CF.CommonNo, CF.MaxLength, CF.FolderNo, F.DateCreated, F.DateModified, F.Name
	, Length = public."Drive_GetLength"(F.FolderNo) 
	, F.ParentNo, F.IsDeleted
	FROM Drive_CommonFolders CF
	INNER JOIN Drive_Folders F ON F.FolderNo = CF.FolderNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
