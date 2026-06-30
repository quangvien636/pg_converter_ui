-- ─── PROCEDURE→FUNCTION: schedule_getcalendarbycalendartype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getcalendarbycalendartype(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarbycalendartype(
    IN calendartype integer DEFAULT 0
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT S.CalendarNo, S.Name
	FROM ScheduleCalendars S
	WHERE Type = schedule_getcalendarbycalendartype.calendartype OR CalendarType = 0
	ORDER BY SortOrder;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
