-- ─── PROCEDURE→FUNCTION: drive_getfilefromfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getfilefromfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getfilefromfolder(
    IN folderno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FileNo, UserNo, DateCreated, DateModified, DateAccessed, Name, Length, FolderNo, IsDeleted
	FROM Drive_Files
	WHERE FolderNo = drive_getfilefromfolder.folderno AND IsDeleted = FALSE AND Name = Name;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
