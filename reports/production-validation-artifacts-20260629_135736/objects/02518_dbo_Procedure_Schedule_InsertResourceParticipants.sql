-- ─── PROCEDURE→FUNCTION: schedule_insertresourceparticipants ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_insertresourceparticipants(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertresourceparticipants(
    IN reservationno integer,
    IN userno integer,
    IN departno integer
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 THEN

		INSERT INTO ScheduleResourceParticipants(ReservationNo, UserNo, DepartNo)
		VALUES(ReservationNo, UserNo,
			DepartNo)
		
	END IF;
	
	ELSE BEGIN
	
		INSERT INTO ScheduleResourceParticipants(ReservationNo, UserNo, DepartNo)
		VALUES(ReservationNo, 0, DepartNo)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
