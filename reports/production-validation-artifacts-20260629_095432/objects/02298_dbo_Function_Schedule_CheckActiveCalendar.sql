-- ─── FUNCTION: schedule_checkactivecalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_checkactivecalendar(integer);
CREATE OR REPLACE FUNCTION public.schedule_checkactivecalendar(
    typecalendar integer
) RETURNS TABLE(
    isactive text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF (TypeCalendar < 3) 
	BEGIN
		RETURN QUERY
		SELECT /* /* TOP 1 */ */ * FROM ScheduleCalendars WHERE Type=schedule_checkactivecalendar.typecalendar AND IsActive = FALSE
	END
	ELSE
	BEGIN
		RETURN QUERY
		SELECT COALESCE(IsActive, 0) AS IsActive  FROM ScheduleCalendarType WHERE Type = schedule_checkactivecalendar.typecalendar
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
