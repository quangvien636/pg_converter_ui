-- ─── FUNCTION: schedule_getmyreservationone ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getmyreservationone();
CREATE OR REPLACE FUNCTION public.schedule_getmyreservationone(
) RETURNS TABLE(
    reservationno text,
    resourceno text,
    name text,
    title text,
    content text,
    reguserno text,
    regusername text,
    startdate text,
    starttime text,
    enddate text,
    endtime text,
    regdate text,
    rsvnstatus text,
    rsvnstatusdesc text,
    reason text,
    processdate text,
    processuserno text,
    processusername text,
    col19 text
)
AS $function$
BEGIN

	UPDATE ScheduleResourceReservations
	SET
		UserView = 1
	WHERE ReservationNo = ReservationNo
	
	RETURN QUERY
	SELECT		
		RR.ReservationNo,
		RR.ResourceNo,
		R.Name,
		RR.Title,
		RR.Content,
		RR.RegUserNo,
		public."COMNGetUserName"(RR.RegUserNo) As RegUserName,
		RR.StartDate,
		RR.StartTime,
		RR.EndDate,
		RR.EndTime,
		RR.RegDate,
		RR.RsvnStatus,
		CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
			 WHEN RR.RsvnStatus = 'RA' THEN '승인'
			 WHEN RR.RsvnStatus = 'RR' THEN '반려'
		END AS RsvnStatusDesc,
		RR.Reason,
		RR.ProcessDate,
		RR.ProcessUserNo,
		public."COMNGetUserName"(RR.ProcessUserNo) As ProcessUserName
		,COALESCE( R.IsHidenReg,0) IsHidenReg
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE RR.ReservationNo = ReservationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
