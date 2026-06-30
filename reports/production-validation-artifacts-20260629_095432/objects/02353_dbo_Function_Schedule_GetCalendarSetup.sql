-- ─── FUNCTION: schedule_getcalendarsetup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getcalendarsetup(integer);
CREATE OR REPLACE FUNCTION public.schedule_getcalendarsetup(
    userno integer
) RETURNS TABLE(
    userno text,
    calendarviewtype text,
    startweek text,
    defaultcalendarno text,
    divisionuseyn text,
    col6 text,
    col7 text
)
AS $function$
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
