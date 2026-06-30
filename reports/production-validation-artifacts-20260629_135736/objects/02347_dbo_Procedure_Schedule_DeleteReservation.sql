-- ─── PROCEDURE→FUNCTION: schedule_deletereservation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deletereservation();
CREATE OR REPLACE FUNCTION public.schedule_deletereservation(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleResourceReservationsHistory
	WHERE ReservationNo = ReservationNo
	
	DELETE FROM ScheduleResourceReservations
	WHERE ReservationNo = ReservationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
