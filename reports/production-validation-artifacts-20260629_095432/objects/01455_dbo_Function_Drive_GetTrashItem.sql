-- ─── FUNCTION: drive_gettrashitem ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_gettrashitem(bigint);
CREATE OR REPLACE FUNCTION public.drive_gettrashitem(
    itemno bigint
) RETURNS TABLE(
    itemno text,
    userno text,
    datedeleted text,
    fullpath text,
    fileno text,
    folderno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT ItemNo, UserNo, DateDeleted, FullPath, FileNo, FolderNo
	FROM Drive_Trash
	WHERE ItemNo = drive_gettrashitem.itemno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
