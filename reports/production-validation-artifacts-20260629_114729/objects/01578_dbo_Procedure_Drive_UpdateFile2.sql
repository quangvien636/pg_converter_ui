-- ─── PROCEDURE→FUNCTION: drive_updatefile2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_updatefile2(bigint, integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_updatefile2(
    IN fileno bigint,
    IN userno integer,
    IN datecreated timestamp without time zone,
    IN datemodified timestamp without time zone,
    IN dateaccessed timestamp without time zone,
    IN name character varying,
    IN length bigint,
    IN folderno bigint,
    IN isdeleted boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SELECT IsDeleted, FolderNo INTO _isdeleted, _folderno FROM Drive_Files WHERE FileNo = drive_updatefile2.fileno

	IF IsDeleted = TRUE AND _IsDeleted = 0 AND FolderNo = _FolderNo THEN

		UPDATE Drive_Folders SET Length = drive_updatefile2.length - Length WHERE FolderNo = drive_updatefile2.folderno

		ParentNo := drive_updatefile2.folderno;
		WHILE 1 = 1 LOOP

			ParentNo := (SELECT ParentNo FROM Drive_Folders WHERE FolderNo = ParentNo);
			IF (ParentNo IN (0, -1)) BREAK THEN

			UPDATE Drive_Folders SET Length = drive_updatefile2.length - Length WHERE FolderNo = ParentNo

		END LOOP;

	END IF;
	
	ELSIF IsDeleted = FALSE AND _IsDeleted = 1 THEN

		UPDATE Drive_Folders SET Length = drive_updatefile2.length + Length WHERE FolderNo = drive_updatefile2.folderno

		ParentNo := drive_updatefile2.folderno;
		WHILE 1 = 1 LOOP

			ParentNo := (SELECT ParentNo FROM Drive_Folders WHERE FolderNo = ParentNo);
			IF (ParentNo IN (0, -1)) BREAK THEN

			UPDATE Drive_Folders SET Length = drive_updatefile2.length + Length WHERE FolderNo = ParentNo

		END LOOP;

	END IF;

	--------------------------------------------

	UPDATE Drive_Files SET
		UserNo = drive_updatefile2.userno,
		DateCreated = drive_updatefile2.datecreated,
		DateModified = drive_updatefile2.datemodified,
		DateAccessed = drive_updatefile2.dateaccessed,
		Name = drive_updatefile2.name,
		Length = drive_updatefile2.length,
		FolderNo = drive_updatefile2.folderno,
		IsDeleted = drive_updatefile2.isdeleted,
		Note = p_note
	WHERE FileNo = drive_updatefile2.fileno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
