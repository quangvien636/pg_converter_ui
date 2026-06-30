-- ─── PROCEDURE→FUNCTION: schedule_updatereservation ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_updatereservation(character varying, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updatereservation(
    IN rsvnstatus character varying,
    IN userno integer,
    IN reason character varying DEFAULT '',
    IN isbatch boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	SeqNo := (COALESCE(MAX(SeqNo),0)+1);
	FROM ScheduleResourceReservationsHistory
	WHERE ReservationNo = ReservationNo
	-- 이전 상태이력 기록...;
	INSERT INTO ScheduleResourceReservationsHistory
	(
		ReservationNo,
		SeqNo,
		RsvnStatus,
		ProcessDate,
		ProcessUserNo,
		Reason,
		RegDate,
		RegUserNo,
		ModDate,
		ModUserNo
	)
	RETURN QUERY
	SELECT
		ReservationNo,
		SeqNo,
		RsvnStatus,
		ProcessDate,
		ProcessUserNo,
		Reason,
		NOW(),
		UserNo,
		NOW(),
		UserNo
	FROM ScheduleResourceReservations
	WHERE ReservationNo = ReservationNo
	-- 상태 업데이트;
	UPDATE ScheduleResourceReservations
	RsvnStatus := schedule_updatereservation.rsvnstatus,;
		Reason = CASE WHEN Reason = '' AND IsBatch = TRUE THEN '일괄처리' ELSE Reason END,  
		ProcessDate = NOW(),
		ProcessUserNo = schedule_updatereservation.userno,
		ProcessView = 0,
		UserView = 0
	WHERE ReservationNo = ReservationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
