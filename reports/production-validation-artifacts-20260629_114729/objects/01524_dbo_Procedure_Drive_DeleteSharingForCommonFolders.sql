-- ─── PROCEDURE→FUNCTION: drive_deletesharingforcommonfolders ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_deletesharingforcommonfolders(bigint);
CREATE OR REPLACE FUNCTION public.drive_deletesharingforcommonfolders(
    IN folderno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	DELETE FROM Drive_SharingForCommonFolders WHERE FolderNo = drive_deletesharingforcommonfolders.folderno

	RETURN QUERY
	SELECT TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
