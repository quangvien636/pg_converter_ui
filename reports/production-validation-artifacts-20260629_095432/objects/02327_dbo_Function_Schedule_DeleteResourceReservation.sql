-- ─── FUNCTION: schedule_deleteresourcereservation ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteresourcereservation(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourcereservation(
    reservationno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleResourceReservations WHERE ReservationNo = schedule_deleteresourcereservation.reservationno;
	DELETE FROM ScheduleResourceParticipants WHERE ReservationNo = schedule_deleteresourcereservation.reservationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
