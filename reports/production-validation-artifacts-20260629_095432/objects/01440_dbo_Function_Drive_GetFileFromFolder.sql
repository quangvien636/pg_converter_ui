-- ─── FUNCTION: drive_getfilefromfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_getfilefromfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getfilefromfolder(
    folderno bigint
) RETURNS TABLE(
    fileno text,
    userno text,
    datecreated text,
    datemodified text,
    dateaccessed text,
    name text,
    length text,
    folderno text,
    isdeleted text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FileNo, UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted
	FROM Drive_Files
	WHERE FolderNo = drive_getfilefromfolder.folderno AND IsDeleted = FALSE AND Name = Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
