-- ─── PROCEDURE→FUNCTION: schedule_getcalendarsetup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getcalendarsetup(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarsetup(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		s.UserNo,
		s.CalendarViewType,
		s.StartWeek,
		c.CalendarNo as DefaultCalendarNo,
		s.DivisionUseYN,
		COALESCE(s.IsFunctionComplete,0) IsFunctionComplete --2024
		,COALESCE(s.is12hours,0)  is12hours
	FROM ScheduleCalendarSetup s
	left join ScheduleCalendars c on s.DefaultCalendarNo = c.CalendarNo
	WHERE UserNo = schedule_getcalendarsetup.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
