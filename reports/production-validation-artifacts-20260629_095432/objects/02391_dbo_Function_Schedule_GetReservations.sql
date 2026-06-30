-- ─── FUNCTION: schedule_getreservations ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservations(integer, character varying, integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservations(
    userno integer,
    rsvnstatus character varying DEFAULT 'RW',
    pagesize integer DEFAULT 10,
    currpage integer DEFAULT 1,
    searchmode integer DEFAULT 0,
    searchtext character varying DEFAULT '',
    searchtext2 character varying DEFAULT ''
) RETURNS TABLE(
    rownum text,
    reservationno text,
    name text,
    reguserno text,
    regusername text,
    startdate text,
    starttime text,
    enddate text,
    endtime text,
    regdate text,
    rsvnstatus text,
    rsvnstatusdesc text,
    processview text
)
AS $function$
BEGIN

	IF SearchMode = 0 -- 전체
	BEGIN
		RETURN QUERY
		SELECT
			*
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
				RR.ProcessView
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = FALSE 
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservations.userno OR B.SubManagerNo = schedule_getreservations.userno)
			AND RsvnStatus = schedule_getreservations.rsvnstatus
			AND 
			(
				R.Name ILIKE '%' || SearchText || '%' OR
				RR.Title ILIKE '%' || SearchText || '%' OR
				public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
			)
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END
	ELSE IF SearchMode = 1 -- 자원명
	BEGIN
		RETURN QUERY
		SELECT
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) AS RowNum,
				RR.ReservationNo,
				R.Name,
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
				RR.ProcessView
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = FALSE 
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservations.userno OR B.SubManagerNo = schedule_getreservations.userno)
			AND RsvnStatus = schedule_getreservations.rsvnstatus
			AND R.Name ILIKE '%' || SearchText || '%'
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END
	ELSE IF SearchMode = 2 -- 예약제목
	BEGIN
		RETURN QUERY
		SELECT
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) AS RowNum,
				RR.ReservationNo,
				R.Name,
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
				RR.ProcessView
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = FALSE 
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservations.userno OR B.SubManagerNo = schedule_getreservations.userno)
			AND RsvnStatus = schedule_getreservations.rsvnstatus
			AND RR.Title ILIKE '%' || SearchText || '%'
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END
	ELSE IF SearchMode = 3 -- 예약일
	BEGIN
		RETURN QUERY
		SELECT
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) AS RowNum,
				RR.ReservationNo,
				R.Name,
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
				RR.ProcessView
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = FALSE 
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservations.userno OR B.SubManagerNo = schedule_getreservations.userno)
			AND RsvnStatus = schedule_getreservations.rsvnstatus
			AND RR.RegDate BETWEEN CONVERT(DATE,SearchText) AND CONVERT(DATE,SearchText2)
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END
	ELSE IF SearchMode = 4 -- 예약자
	BEGIN
		RETURN QUERY
		SELECT
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) AS RowNum,
				RR.ReservationNo,
				R.Name,
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
				RR.ProcessView
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = FALSE 
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservations.userno OR B.SubManagerNo = schedule_getreservations.userno)
			AND RsvnStatus = schedule_getreservations.rsvnstatus
			AND public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
