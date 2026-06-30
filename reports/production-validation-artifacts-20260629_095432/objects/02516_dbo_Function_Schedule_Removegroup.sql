-- ─── FUNCTION: schedule_removegroup ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_removegroup(integer);
CREATE OR REPLACE FUNCTION public.schedule_removegroup(
    p_no integer
) RETURNS TABLE(
    reservationno text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
DECLARE
    resourceno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ ResourceNo = ResourceNo  FROM ScheduleResources WHERE BuyGroupNo = schedule_removegroup.p_no	;
	DELETE FROM ScheduleResourceReservationsHistory 
	WHERE ReservationNo IN (SELECT ReservationNo FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo);;
	DELETE FROM ScheduleResourceReservations 
	WHERE ReservationNo IN (SELECT ReservationNo FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo);;
	DELETE FROM ScheduleResourcesRepair WHERE ResourceNo = ResourceNo;;
	DELETE FROM ScheduleResourcesDispose WHERE ResourceNo = ResourceNo;;
	DELETE FROM ScheduleResources WHERE ResourceNo = ResourceNo;
	
	DELETE FROM ScheduleResourcesBuyGroup WHERE BuyGroupNo = schedule_removegroup.p_no;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
