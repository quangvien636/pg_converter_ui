-- ─── FUNCTION: schedule_getreservationone ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservationone(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getreservationone(
    ispostback boolean DEFAULT TRUE
) RETURNS TABLE(
    reservationno text,
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
    processusername text
)
AS $function$
BEGIN

	IF IsPostBack = FALSE
	BEGIN;
		UPDATE ScheduleResourceReservations
		SET
			ProcessView = 1
		WHERE ReservationNo = ReservationNo
	END
	RETURN QUERY
	SELECT		
		RR.ReservationNo,
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
	FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE RR.ReservationNo = ReservationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
