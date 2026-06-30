-- ─── PROCEDURE→FUNCTION: schedule_deleteresourcereservation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteresourcereservation(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourcereservation(
    IN reservationno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleResourceReservations WHERE ReservationNo = schedule_deleteresourcereservation.reservationno;
	DELETE FROM ScheduleResourceParticipants WHERE ReservationNo = schedule_deleteresourcereservation.reservationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
