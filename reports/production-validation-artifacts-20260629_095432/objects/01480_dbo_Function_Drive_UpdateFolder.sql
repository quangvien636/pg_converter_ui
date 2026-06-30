-- ─── FUNCTION: drive_updatefolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_updatefolder(bigint, integer, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_updatefolder(
    folderno bigint,
    userno integer,
    datecreated timestamp without time zone,
    datemodified timestamp without time zone,
    name character varying,
    length bigint,
    parentno bigint,
    isdeleted boolean
) RETURNS TABLE(
    true text
)
AS $function$
BEGIN


	

	UPDATE Drive_Folders SET
		UserNo = drive_updatefolder.userno,
		DateCreated = drive_updatefolder.datecreated,
		DateModified = drive_updatefolder.datemodified,
		Name = drive_updatefolder.name, 
		Length = drive_updatefolder.length,
		ParentNo = drive_updatefolder.parentno,
		IsDeleted = drive_updatefolder.isdeleted
	WHERE FolderNo = drive_updatefolder.folderno;

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
