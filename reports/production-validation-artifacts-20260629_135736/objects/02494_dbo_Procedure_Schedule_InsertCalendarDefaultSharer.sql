-- ─── PROCEDURE→FUNCTION: schedule_insertcalendardefaultsharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertcalendardefaultsharer(integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendardefaultsharer(
    IN calendarno integer,
    IN userid character varying,
    IN departno integer,
    IN positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 AND PositionNo = 0 THEN

		INSERT INTO ScheduleCalendarDefaultSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, UserID,0,0)
		
	END IF;
	
	ELSIF DepartNo > 0 AND PositionNo = 0 THEN
	
		INSERT INTO ScheduleCalendarDefaultSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, DepartNo, 0)
	
	END IF;
	
	ELSIF DepartNo = 0 AND PositionNo > 0 THEN
	
		INSERT INTO ScheduleCalendarDefaultSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, 0, PositionNo)
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
