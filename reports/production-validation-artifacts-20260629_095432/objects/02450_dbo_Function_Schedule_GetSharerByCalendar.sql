-- ─── FUNCTION: schedule_getsharerbycalendar ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getsharerbycalendar(integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getsharerbycalendar(
    calendarno integer,
    calendartype integer
) RETURNS TABLE(
    userno text,
    departno text,
    calendarno text,
    positionno text
)
AS $function$
BEGIN

	if(CalendarType = 2)
	begin
		RETURN QUERY
		select UserNo,DepartNo,CalendarNo,PositionNo
		from ScheduleCalendarDefaultSharers where CalendarNo = schedule_getsharerbycalendar.calendarno
	end
	else if(CalendarType = 3 or CalendarType = 4)
	begin
		RETURN QUERY
		select UserNo,DepartNo,CalendarNo,PositionNo
		from ScheduleCalendarSharers where CalendarNo = schedule_getsharerbycalendar.calendarno
	end;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
