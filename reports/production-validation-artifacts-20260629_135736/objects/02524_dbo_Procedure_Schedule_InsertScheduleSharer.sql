-- ─── PROCEDURE→FUNCTION: schedule_insertschedulesharer ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertschedulesharer(integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertschedulesharer(
    IN scheduleno integer,
    IN userno integer,
    IN departno integer,
    IN positionno integer DEFAULT 0
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 AND PositionNo = 0 THEN

		INSERT INTO ScheduleContentSharers(ScheduleNo, UserNo, DepartNo, PositionNo)
		VALUES(ScheduleNo, UserNo, 0, 0)
		
	END IF;
	
	ELSIF DepartNo > 0 AND PositionNo = 0 THEN
	
		INSERT INTO ScheduleContentSharers (ScheduleNo, UserNo, DepartNo, PositionNo)
		VALUES (ScheduleNo, 0, DepartNo, 0)
	
	END IF;

	ELSIF DepartNo = 0 AND PositionNo > 0 THEN
	
		INSERT INTO ScheduleContentSharers (ScheduleNo, UserNo, DepartNo, PositionNo)
		VALUES (ScheduleNo, 0, 0, PositionNo)
	
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
