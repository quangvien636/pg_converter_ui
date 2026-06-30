-- ─── FUNCTION: schedule_getresourceforusedetaillistcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourceforusedetaillistcount(date);
CREATE OR REPLACE FUNCTION public.schedule_getresourceforusedetaillistcount(
    seldate date
) RETURNS TABLE(
    rownum text,
    reservationno text,
    name text,
    reguserno text,
    regusername text,
    title text,
    startdate text,
    starttime text,
    enddate text,
    endtime text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT 
		COUNT(*) AS CNT
	FROM
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) AS RowNum,
			RR.ReservationNo,
			R.Name,
			RR.RegUserNo,
			public."COMNGetUserName"(RR.RegUserNo) As RegUserName,
			RR.Title,
			RR.StartDate,
			RR.StartTime,
			RR.EndDate,
			RR.EndTime
		FROM ScheduleResourceReservations RR
		LEFT JOIN ScheduleResources R ON R.ResourceNo  = RR.ResourceNo
		WHERE R.BuyGroupNo = BuyGroupNo
		AND SelDate BETWEEN RR.StartDate AND RR.EndDate
	) A;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
