-- ─── PROCEDURE→FUNCTION: drive_updatefolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_updatefolder(bigint, integer, timestamp without time zone, timestamp without time zone, character varying, bigint, bigint, boolean);
CREATE OR REPLACE FUNCTION public.drive_updatefolder(
    IN folderno bigint,
    IN userno integer,
    IN datecreated timestamp without time zone,
    IN datemodified timestamp without time zone,
    IN name character varying,
    IN length bigint,
    IN parentno bigint,
    IN isdeleted boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
