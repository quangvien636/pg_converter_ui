-- ─── PROCEDURE→FUNCTION: drive_deleteallofsharingforcommonfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_deleteallofsharingforcommonfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_deleteallofsharingforcommonfolder(
    IN folderno bigint
) RETURNS SETOF record
AS $function$
DECLARE
    folders table ( folderno bigint );
    tempfolders table ( folderno bigint );
    tempfolders2 table ( folderno bigint );
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





	INSERT INTO Folders VALUES (FolderNo);
	INSERT INTO TempFolders2 VALUES (FolderNo)

	WHILE 1 = 1 LOOP

		INSERT INTO TempFolders
		RETURN QUERY
		SELECT FolderNo FROM Drive_Folders WHERE ParentNo IN (SELECT FolderNo FROM TempFolders2)

		IF ((SELECT COUNT(*) FROM TempFolders) = 0) BREAK THEN

		INSERT INTO Folders SELECT FolderNo FROM TempFolders

		DELETE FROM TempFolders2;
		INSERT INTO TempFolders2 SELECT FolderNo FROM TempFolders

		DELETE FROM TempFolders

	END LOOP;

	DELETE FROM Drive_SharingForCommonFolders WHERE FolderNo IN (SELECT FolderNo FROM Folders)

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
