-- ─── PROCEDURE→FUNCTION: drive_insertfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_insertfile(integer, timestamp without time zone, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_insertfile(
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
DECLARE
    fileno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Drive_Files (UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted)
	VALUES (UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted)


	FileNo := lastval();
	RETURN QUERY
	SELECT FileNo

	-------------------------------------------------------------------------

	UPDATE Drive_Folders SET Length = drive_insertfile.length + Length WHERE FolderNo = drive_insertfile.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
