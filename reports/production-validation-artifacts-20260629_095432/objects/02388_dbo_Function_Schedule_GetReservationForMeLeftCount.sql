-- ─── FUNCTION: schedule_getreservationformeleftcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservationformeleftcount();
CREATE OR REPLACE FUNCTION public.schedule_getreservationformeleftcount(
) RETURNS TABLE(
    a_cnt text,
    w_cnt text,
    r_cnt text,
    a_cnt text,
    w_cnt text,
    col6 text
)
AS $function$
BEGIN






	SELECT A_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE RR.RegUserNo = UserNo
	AND RR.UserView = 0
	and RsvnStatus = 'RA'
	GROUP BY RsvnStatus

	SELECT W_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE RR.RegUserNo = UserNo
	AND RR.UserView = 0
	and RsvnStatus = 'RW'
	--AND R.IsReservation = TRUE
	GROUP BY RsvnStatus

	SELECT R_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE RR.RegUserNo = UserNo
	AND RR.UserView = 0
	and RsvnStatus = 'RR'
	GROUP BY RsvnStatus

	SELECT All_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE RR.RegUserNo = UserNo
	AND RR.UserView = 0
	--and RsvnStatus = 'RR'
	--GROUP BY RsvnStatus

	RETURN QUERY
	select A_CNT as A_CNT, W_CNT as W_CNT, R_CNT as R_CNT, All_CNT as All_CNT;


	--SELECT
	--	COALESCE(SUM(A_CNT),0) AS A_CNT, -- 승인건수
	--	COALESCE(SUM(W_CNT),0) AS W_CNT, -- 대기건수
	--	COALESCE(SUM(R_CNT),0) AS R_CNT  -- 반려건수
	--FROM
	--(
	--	SELECT 
	--		CASE WHEN RsvnStatus = 'RA' THEN COUNT(ReservationNo) END AS A_CNT,
	--		CASE WHEN RsvnStatus = 'RW' THEN COUNT(ReservationNo) END AS W_CNT,
	--		CASE WHEN RsvnStatus = 'RR' THEN COUNT(ReservationNo) END AS R_CNT
	--	FROM ScheduleResourceReservations RR
	--	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	--	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	--	WHERE RR.RegUserNo = UserNo
	--	--AND R.IsReservation = FALSE
	--	AND RR.UserView = 0
	--	GROUP BY RsvnStatus
	--) A
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
