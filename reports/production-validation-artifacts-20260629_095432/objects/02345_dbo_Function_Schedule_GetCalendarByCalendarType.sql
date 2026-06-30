-- ─── FUNCTION: schedule_getcalendarbycalendartype ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarbycalendartype(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarbycalendartype(
    calendartype integer DEFAULT 0
) RETURNS TABLE(
    calendarno text,
    name text
)
AS $function$
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
