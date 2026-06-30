-- ─── FUNCTION: schedule_deleteresourceparticipants ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deleteresourceparticipants(integer);
CREATE OR REPLACE FUNCTION public.schedule_deleteresourceparticipants(
    reservationno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM ScheduleResourceParticipants WHERE ReservationNo = schedule_deleteresourceparticipants.reservationno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
