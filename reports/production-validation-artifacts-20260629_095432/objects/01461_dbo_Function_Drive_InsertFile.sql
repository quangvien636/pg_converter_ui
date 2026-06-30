-- ─── FUNCTION: drive_insertfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_insertfile(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_insertfile(
    userno integer,
    datecreated timestamp without time zone,
    datemodified timestamp without time zone,
    dateaccessed timestamp without time zone,
    name character varying,
    length bigint,
    folderno bigint,
    isdeleted boolean
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    fileno bigint;
BEGIN


	INSERT INTO Drive_Files (UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted)
	VALUES (UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted)


	SET FileNo = lastval()

	RETURN QUERY
	SELECT FileNo

	-------------------------------------------------------------------------

	UPDATE Drive_Folders SET Length = drive_insertfile.length + Length WHERE FolderNo = drive_insertfile.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
