-- ─── PROCEDURE→FUNCTION: schedule_removegroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_removegroup(integer);
CREATE OR REPLACE FUNCTION public.schedule_removegroup(
    IN p_no integer
) RETURNS SETOF record
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
