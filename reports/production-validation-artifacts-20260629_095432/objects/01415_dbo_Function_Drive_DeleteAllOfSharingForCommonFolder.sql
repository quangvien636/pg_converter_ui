-- ─── FUNCTION: drive_deleteallofsharingforcommonfolder ───────────────────────────────
DROP FUNCTION IF EXISTS public.drive_deleteallofsharingforcommonfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_deleteallofsharingforcommonfolder(
    folderno bigint
) RETURNS TABLE(
    folderno text
)
AS $function$
DECLARE
    folders table ( folderno bigint );
    tempfolders table ( folderno bigint );
    tempfolders2 table ( folderno bigint );
BEGIN





	INSERT INTO Folders VALUES (FolderNo);
	INSERT INTO TempFolders2 VALUES (FolderNo)

	WHILE (1 = 1) BEGIN

		INSERT INTO TempFolders
		RETURN QUERY
		SELECT FolderNo FROM Drive_Folders WHERE ParentNo IN (SELECT FolderNo FROM TempFolders2)

		IF ((SELECT COUNT(*) FROM TempFolders) = 0) BREAK

		INSERT INTO Folders SELECT FolderNo FROM TempFolders

		DELETE FROM TempFolders2;
		INSERT INTO TempFolders2 SELECT FolderNo FROM TempFolders

		DELETE FROM TempFolders

	END

	DELETE FROM Drive_SharingForCommonFolders WHERE FolderNo IN (SELECT FolderNo FROM Folders)

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
