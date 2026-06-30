-- ─── FUNCTION: schedule_removeresourceall ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_removeresourceall();
CREATE OR REPLACE FUNCTION public.schedule_removeresourceall(
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    buygroupno integer;
    r_cnt integer;
BEGIN

	-- 삭제할 연관정보 조회
	--DECLARE ReservationNo INT


	--SELECT ReservationNo = ReservationNo FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo;
	SELECT BuyGroupNo = BuyGroupNo FROM ScheduleResources WHERE ResourceNo = ResourceNo
	-- 삭제 시작...
	
	DELETE FROM ScheduleResourceReservationsHistory 
	WHERE ReservationNo IN (SELECT ReservationNo FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo);;
	DELETE FROM ScheduleResourceReservations 
	WHERE ReservationNo IN (SELECT ReservationNo FROM ScheduleResourceReservations WHERE ResourceNo = ResourceNo);;
	DELETE FROM ScheduleResourcesRepair WHERE ResourceNo = ResourceNo;;
	DELETE FROM ScheduleResourcesDispose WHERE ResourceNo = ResourceNo;;
	DELETE FROM ScheduleResources WHERE ResourceNo = ResourceNo;
	
	SELECT R_CNT = COUNT(*) FROM ScheduleResources WHERE BuyGroupNo = BuyGroupNo;
	
	IF R_CNT = 0
	BEGIN;
		DELETE FROM ScheduleResourcesBuyGroup WHERE BuyGroupNo = BuyGroupNo;
	END
	ELSE
	BEGIN;
		UPDATE ScheduleResourcesBuyGroup
		SET
			BuyQty = BuyQty - 1
		WHERE BuyGroupNo = BuyGroupNo
	END
	RETURN QUERY
	select 0;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
