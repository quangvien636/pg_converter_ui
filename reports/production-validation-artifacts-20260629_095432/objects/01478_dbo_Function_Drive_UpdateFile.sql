-- ─── FUNCTION: drive_updatefile ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_updatefile(bigint, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_updatefile(
    fileno bigint,
    userno integer,
    datecreated timestamp without time zone,
    datemodified timestamp without time zone,
    dateaccessed timestamp without time zone,
    name character varying,
    length bigint,
    folderno bigint,
    isdeleted boolean
) RETURNS TABLE(
    parentno text
)
AS $function$
BEGIN



	SELECT _IsDeleted = drive_updatefile.isdeleted, _FolderNo = drive_updatefile.folderno FROM Drive_Files WHERE FileNo = drive_updatefile.fileno

	IF (IsDeleted = TRUE AND _IsDeleted = 0 AND FolderNo = _FolderNo) BEGIN

		UPDATE Drive_Folders SET Length = drive_updatefile.length - Length WHERE FolderNo = drive_updatefile.folderno

		SET ParentNo = drive_updatefile.folderno

		WHILE (1 = 1) BEGIN

			SET ParentNo = (SELECT ParentNo FROM Drive_Folders WHERE FolderNo = ParentNo)

			IF (ParentNo IN (0, -1)) BREAK

			UPDATE Drive_Folders SET Length = drive_updatefile.length - Length WHERE FolderNo = ParentNo

		END

	END
	
	ELSE IF (IsDeleted = FALSE AND _IsDeleted = 1) BEGIN

		UPDATE Drive_Folders SET Length = drive_updatefile.length + Length WHERE FolderNo = drive_updatefile.folderno

		SET ParentNo = drive_updatefile.folderno

		WHILE (1 = 1) BEGIN

			SET ParentNo = (SELECT ParentNo FROM Drive_Folders WHERE FolderNo = ParentNo)

			IF (ParentNo IN (0, -1)) BREAK

			UPDATE Drive_Folders SET Length = drive_updatefile.length + Length WHERE FolderNo = ParentNo

		END

	END

	--------------------------------------------

	UPDATE Drive_Files SET
		UserNo = drive_updatefile.userno,
		DateCreated = drive_updatefile.datecreated,
		DateModified = drive_updatefile.datemodified,
		DateAccessed = drive_updatefile.dateaccessed,
		Name = drive_updatefile.name,
		Length = drive_updatefile.length,
		FolderNo = drive_updatefile.folderno,
		IsDeleted = drive_updatefile.isdeleted
	WHERE FileNo = drive_updatefile.fileno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
