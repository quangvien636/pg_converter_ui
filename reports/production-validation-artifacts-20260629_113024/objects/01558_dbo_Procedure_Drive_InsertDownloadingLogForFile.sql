-- ─── PROCEDURE→FUNCTION: drive_insertdownloadinglogforfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.drive_insertdownloadinglogforfile(bigint, integer, timestamp without time zone);
CREATE OR REPLACE FUNCTION public.drive_insertdownloadinglogforfile(
    IN fileno bigint,
    IN userno integer,
    IN datedownloaded timestamp without time zone
) RETURNS SETOF record
AS $function$
DECLARE
    logno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO Drive_DownloadingLogsForFile (FileNo, UserNo, DateDownloaded)
	VALUES (FileNo, UserNo, DateDownloaded)


	LogNo := lastval();
	RETURN QUERY
	SELECT LogNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
