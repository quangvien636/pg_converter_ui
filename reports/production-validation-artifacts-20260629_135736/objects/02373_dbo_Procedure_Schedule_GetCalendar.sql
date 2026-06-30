-- ─── PROCEDURE→FUNCTION: schedule_getcalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getcalendar(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendar(
    IN calendarno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT CalendarNo, RegUserNo, RegDate, ModUserNo, ModDate, Name, Type, Color, UseLevel, Description,
		IsNotiNote, IsNotiMail, IsNotiSMS, IsNotiPopup, NotiTimeType, IsFixed, COALESCE(isall,0) isall
		, COALESCE(isDetail,0) isDetail
		, COALESCE(Detail,'') Detail
	FROM ScheduleCalendars 
	WHERE CalendarNo = schedule_getcalendar.calendarno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
