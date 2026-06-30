-- ─── FUNCTION: schedule_insertschedulesharer ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertschedulesharer(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertschedulesharer(
    scheduleno integer,
    userno integer,
    departno integer,
    positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 AND PositionNo = 0 BEGIN

		INSERT INTO ScheduleContentSharers(ScheduleNo, UserNo, DepartNo, PositionNo)
		VALUES(ScheduleNo, UserNo, 0, 0)
		
	END
	
	ELSE IF DepartNo > 0 AND PositionNo = 0 BEGIN
	
		INSERT INTO ScheduleContentSharers (ScheduleNo, UserNo, DepartNo, PositionNo)
		VALUES (ScheduleNo, 0, DepartNo, 0)
	
	END

	ELSE IF DepartNo = 0 AND PositionNo > 0 BEGIN
	
		INSERT INTO ScheduleContentSharers (ScheduleNo, UserNo, DepartNo, PositionNo)
		VALUES (ScheduleNo, 0, 0, PositionNo)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
