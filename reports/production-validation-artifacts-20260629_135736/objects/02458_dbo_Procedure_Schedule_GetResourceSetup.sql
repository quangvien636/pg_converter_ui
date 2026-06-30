-- ─── PROCEDURE→FUNCTION: schedule_getresourcesetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcesetup();
CREATE OR REPLACE FUNCTION public.schedule_getresourcesetup(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		UserNo,
		ViewType,
		ViewCount,
		StartWeek,
		RsvnMethod,
		RegUserNo,
		RegDate,
		ModUserNo,
		ModDate,
		COALESCE(can,0) can
	FROM ScheduleResourceSetup
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
