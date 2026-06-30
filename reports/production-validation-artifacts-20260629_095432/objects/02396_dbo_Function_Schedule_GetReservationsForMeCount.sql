-- ─── FUNCTION: schedule_getreservationsformecount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservationsformecount(character varying, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservationsformecount(
    rsvnstatus character varying DEFAULT 'RW',
    searchmode integer DEFAULT 0,
    searchtext character varying DEFAULT '',
    searchtext1 character varying DEFAULT '',
    searchtext2 character varying DEFAULT ''
) RETURNS TABLE(
    rownum text,
    reservationno text,
    name text,
    title text,
    reguserno text,
    regusername text,
    startdate text,
    starttime text,
    enddate text,
    endtime text,
    regdate text,
    rsvnstatus text,
    rsvnstatusdesc text,
    reason text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	if(SearchText1 != '' and SearchText2 != '' )
	begin
		set DateNull = 1
	end

	IF SearchMode = 0 -- 전체
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
				RR.Title,
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
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE 
			--R.IsReservation = TRUE and 
			RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsformecount.rsvnstatus or RsvnStatus = schedule_getreservationsformecount.rsvnstatus)
			AND 
			(
				R.Name ILIKE '%' || SearchText || '%' OR
				RR.Title ILIKE '%' || SearchText || '%'
			)
			--AND RR.UserView = 0
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,SearchText1) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))))
		) A
	END
	ELSE IF SearchMode = 1 -- 자원명
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
				RR.Title,
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
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = TRUE 
			AND RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsformecount.rsvnstatus or RsvnStatus = schedule_getreservationsformecount.rsvnstatus)
			AND R.Name ILIKE '%' || SearchText || '%'
				
		) A
	END
	ELSE IF SearchMode = 2 -- 예약제목
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
				RR.Title,
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
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = TRUE 
			AND RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsformecount.rsvnstatus or RsvnStatus = schedule_getreservationsformecount.rsvnstatus)
			AND RR.Title ILIKE '%' || SearchText || '%'
		) A
	END
	ELSE IF SearchMode = 3 -- 신청일자
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
				RR.Title,
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
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = TRUE 
			AND RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsformecount.rsvnstatus or RsvnStatus = schedule_getreservationsformecount.rsvnstatus)
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,SearchText1) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))))
		) A
	END
	ELSE IF SearchMode = 5 -- 전체
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
				RR.Title,
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
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = TRUE 
			and RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsformecount.rsvnstatus or RsvnStatus = schedule_getreservationsformecount.rsvnstatus)
			AND	public."COMNGetUserName"(RR.RegUserNo)  ILIKE '%' || SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,SearchText1) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))))
		) A
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
