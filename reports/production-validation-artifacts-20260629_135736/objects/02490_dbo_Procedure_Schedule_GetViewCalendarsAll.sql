-- ─── PROCEDURE→FUNCTION: schedule_getviewcalendarsall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getviewcalendarsall(integer);
CREATE OR REPLACE FUNCTION public.schedule_getviewcalendarsall(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT UserNo, RegUserNo, RegDate, ModUserNo, ModDate,
		IsToDoView, IsDdayView, IsCompanyView, IsPersonalView, IsShareView, IsAllView,  ViewCalendars
	FROM ScheduleViewCalendars
	WHERE UserNo = schedule_getviewcalendarsall.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
