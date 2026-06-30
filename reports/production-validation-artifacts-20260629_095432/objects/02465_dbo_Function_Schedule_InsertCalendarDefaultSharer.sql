-- ─── FUNCTION: schedule_insertcalendardefaultsharer ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertcalendardefaultsharer(integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendardefaultsharer(
    calendarno integer,
    userid character varying,
    departno integer,
    positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 AND PositionNo = 0
	BEGIN

		INSERT INTO ScheduleCalendarDefaultSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, UserID,0,0)
		
	END
	
	ELSE IF DepartNo > 0 AND PositionNo = 0
	BEGIN
	
		INSERT INTO ScheduleCalendarDefaultSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, DepartNo, 0)
	
	END
	
	ELSE IF DepartNo = 0 AND PositionNo > 0
	BEGIN
	
		INSERT INTO ScheduleCalendarDefaultSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, 0, PositionNo)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
