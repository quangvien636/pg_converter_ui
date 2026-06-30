-- ─── PROCEDURE→FUNCTION: schedule_getsharerbycalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getsharerbycalendar(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getsharerbycalendar(
    IN calendarno integer,
    IN calendartype integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	if(CalendarType = 2)
	begin
		RETURN QUERY
		select UserNo,DepartNo,CalendarNo,PositionNo
		from ScheduleCalendarDefaultSharers where CalendarNo = schedule_getsharerbycalendar.calendarno
	END;
	else if(CalendarType = 3 or CalendarType = 4)
	begin
		RETURN QUERY
		select UserNo,DepartNo,CalendarNo,PositionNo
		from ScheduleCalendarSharers where CalendarNo = schedule_getsharerbycalendar.calendarno
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
