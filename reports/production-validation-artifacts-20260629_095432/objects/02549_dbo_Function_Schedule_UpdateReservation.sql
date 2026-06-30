-- ─── FUNCTION: schedule_updatereservation ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_updatereservation(character varying, integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.schedule_updatereservation(
    rsvnstatus character varying,
    userno integer,
    reason character varying DEFAULT '',
    isbatch boolean DEFAULT FALSE
) RETURNS TABLE(
    reservationno text,
    seqno text,
    rsvnstatus text,
    processdate text,
    processuserno text,
    reason text,
    col7 text,
    userno text,
    col9 text,
    userno text
)
AS $function$
BEGIN



	SELECT SeqNo = COALESCE(MAX(SeqNo),0)+1 
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
	SET
		RsvnStatus = schedule_updatereservation.rsvnstatus,
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
