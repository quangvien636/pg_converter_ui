-- ─── FUNCTION: schedule_insertcalendarsharer ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertcalendarsharer(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendarsharer(
    calendarno integer,
    userno integer,
    departno integer,
    positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 AND PositionNo = 0
	BEGIN

		INSERT INTO ScheduleCalendarSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, UserNo,0,0)
		
	END
	
	ELSE IF DepartNo > 0 AND PositionNo = 0
	BEGIN
	
		INSERT INTO ScheduleCalendarSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, DepartNo, 0)
	
	END
	ELSE IF DepartNo = 0 AND PositionNo > 0
	BEGIN
	
		INSERT INTO ScheduleCalendarSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, 0, PositionNo)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
