-- ─── PROCEDURE→FUNCTION: drive_getsharingforfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getsharingforfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getsharingforfolder(
    IN folderno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT SharingNo, FolderNo, UserNo, DepartNo
	FROM Drive_SharingForFolders
	WHERE FolderNo = drive_getsharingforfolder.folderno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
