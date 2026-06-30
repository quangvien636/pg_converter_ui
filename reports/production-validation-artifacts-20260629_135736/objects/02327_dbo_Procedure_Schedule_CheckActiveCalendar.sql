-- ─── PROCEDURE→FUNCTION: schedule_checkactivecalendar ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_checkactivecalendar(integer);
CREATE OR REPLACE FUNCTION public.schedule_checkactivecalendar(
    IN typecalendar integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF TypeCalendar < 3 THEN
		RETURN QUERY
		SELECT /* /* TOP 1 */ */ * FROM ScheduleCalendars WHERE Type=schedule_checkactivecalendar.typecalendar AND IsActive = FALSE
	END IF;
	ELSE
		RETURN QUERY
		SELECT COALESCE(IsActive, 0) AS IsActive  FROM ScheduleCalendarType WHERE Type = schedule_checkactivecalendar.typecalendar
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
