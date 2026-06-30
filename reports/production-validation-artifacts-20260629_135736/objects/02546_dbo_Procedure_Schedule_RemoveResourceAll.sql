-- ─── PROCEDURE→FUNCTION: schedule_removeresourceall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_removeresourceall();
CREATE OR REPLACE FUNCTION public.schedule_removeresourceall(
) RETURNS SETOF record
AS $function$
DECLARE
    buygroupno integer;
    r_cnt integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- 삭제할 연관정보 조회
	--DECLARE ReservationNo INT


	--SELECT ReservationNo INTO reservationno FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo;
	SELECT BuyGroupNo INTO buygroupno FROM ScheduleResources WHERE ResourceNo = ResourceNo
	-- 삭제 시작...
	
	DELETE FROM ScheduleResourceReservationsHistory 
	WHERE ReservationNo IN (SELECT ReservationNo FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo);;
	DELETE FROM ScheduleResourceReservations 
	WHERE ReservationNo IN (SELECT ReservationNo FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo);;
	DELETE FROM ScheduleResourcesRepair WHERE ResourceNo = ResourceNo;;
	DELETE FROM ScheduleResourcesDispose WHERE ResourceNo = ResourceNo;;
	DELETE FROM ScheduleResources WHERE ResourceNo = ResourceNo;
	
	SELECT COUNT(*) INTO r_cnt FROM ScheduleResources WHERE BuyGroupNo = BuyGroupNo;
	
	IF R_CNT = 0 THEN;
		DELETE FROM ScheduleResourcesBuyGroup WHERE BuyGroupNo = BuyGroupNo;
	END IF;
	ELSE;
		UPDATE ScheduleResourcesBuyGroup
		BuyQty := BuyQty - 1;
		WHERE BuyGroupNo = BuyGroupNo
	END IF;
	RETURN QUERY
	select 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
