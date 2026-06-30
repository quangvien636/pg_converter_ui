-- ─── PROCEDURE→FUNCTION: schedule_deleteresourceparticipants ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteresourceparticipants(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourceparticipants(
    IN reservationno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleResourceParticipants WHERE ReservationNo = schedule_deleteresourceparticipants.reservationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
