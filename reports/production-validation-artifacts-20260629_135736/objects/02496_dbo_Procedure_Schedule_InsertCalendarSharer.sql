-- ─── PROCEDURE→FUNCTION: schedule_insertcalendarsharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertcalendarsharer(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertcalendarsharer(
    IN calendarno integer,
    IN userno integer,
    IN departno integer,
    IN positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 AND PositionNo = 0 THEN

		INSERT INTO ScheduleCalendarSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, UserNo,0,0)
		
	END IF;
	
	ELSIF DepartNo > 0 AND PositionNo = 0 THEN
	
		INSERT INTO ScheduleCalendarSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, DepartNo, 0)
	
	END IF;
	ELSIF DepartNo = 0 AND PositionNo > 0 THEN
	
		INSERT INTO ScheduleCalendarSharers(CalendarNo, UserNo, DepartNo, PositionNo)
		VALUES(CalendarNo, 0, 0, PositionNo)
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
