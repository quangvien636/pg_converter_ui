-- ─── PROCEDURE→FUNCTION: drive_getdownloadinglogsforfolder ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_getdownloadinglogsforfolder(bigint);
CREATE OR REPLACE FUNCTION public.drive_getdownloadinglogsforfolder(
    IN folderno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LogNo, FolderNo, UserNo, DateDownloaded
	FROM Drive_DownloadingLogsForFolder
	WHERE FolderNo = drive_getdownloadinglogsforfolder.folderno
	ORDER BY LogNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
