-- ─── FUNCTION: schedule_getresourceforusedetaillist ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourceforusedetaillist(date, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourceforusedetaillist(
    seldate date,
    pagesize integer DEFAULT 10,
    currpage integer DEFAULT 1
) RETURNS TABLE(
    rownum text,
    reservationno text,
    resourceno text,
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
		*
	FROM
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) AS RowNum,
			RR.ReservationNo,
			RR.ResourceNo,
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
	) A
	WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
