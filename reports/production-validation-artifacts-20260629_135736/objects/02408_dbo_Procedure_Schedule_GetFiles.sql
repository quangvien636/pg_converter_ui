-- ─── PROCEDURE→FUNCTION: schedule_getfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getfiles();
CREATE OR REPLACE FUNCTION public.schedule_getfiles(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		AttachNo,
		ScheduleNo,
		FileName,
		FileLength,
		FilePath
	FROM ScheduleContentsAttachments
	WHERE ScheduleNo = ScheduleNo
	ORDER BY AttachNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
