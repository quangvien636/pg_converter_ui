-- ─── FUNCTION: schedule_getreservationleftcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservationleftcount(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getreservationleftcount(
    isadmin boolean DEFAULT FALSE
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN






	SELECT A_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	and RsvnStatus = 'RA'
	AND R.IsReservation = FALSE
	GROUP BY RsvnStatus

	SELECT W_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	and RsvnStatus = 'RW'
	AND R.IsReservation = FALSE
	GROUP BY RsvnStatus

	SELECT R_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	and RsvnStatus = 'RR'
	AND R.IsReservation = FALSE
	GROUP BY RsvnStatus

	SELECT All_CNT =  COUNT(ReservationNo)
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	AND R.IsReservation = FALSE
	--GROUP BY RsvnStatus

	RETURN QUERY
	select A_CNT as A_CNT, W_CNT as W_CNT, R_CNT as R_CNT, All_CNT as All_CNT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
