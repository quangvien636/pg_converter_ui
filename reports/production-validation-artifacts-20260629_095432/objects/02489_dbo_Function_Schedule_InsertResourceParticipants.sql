-- ─── FUNCTION: schedule_insertresourceparticipants ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_insertresourceparticipants(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_insertresourceparticipants(
    reservationno integer,
    userno integer,
    departno integer
) RETURNS void
AS $function$
BEGIN


	IF DepartNo = 0 BEGIN

		INSERT INTO ScheduleResourceParticipants(ReservationNo, UserNo, DepartNo)
		VALUES(ReservationNo, UserNo,
			DepartNo)
		
	END
	
	ELSE BEGIN
	
		INSERT INTO ScheduleResourceParticipants(ReservationNo, UserNo, DepartNo)
		VALUES(ReservationNo, 0, DepartNo)
	
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
