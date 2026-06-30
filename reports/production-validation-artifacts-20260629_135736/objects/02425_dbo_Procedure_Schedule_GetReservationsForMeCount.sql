-- ─── PROCEDURE→FUNCTION: schedule_getreservationsformecount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.schedule_getreservationsformecount(character varying, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservationsformecount(
    IN rsvnstatus character varying DEFAULT 'RW',
    IN searchmode integer DEFAULT 0,
    IN searchtext character varying DEFAULT '',
    IN searchtext1 character varying DEFAULT '',
    IN searchtext2 character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	if(SearchText1 != '' and SearchText2 != '' )
	begin
		DateNull := 1;
	END;

	IF SearchMode = 0 -- 전체 THEN
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
	END IF;
	ELSIF SearchMode = 1 -- 자원명 THEN
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
	END IF;
	ELSIF SearchMode = 2 -- 예약제목 THEN
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
	END IF;
	ELSIF SearchMode = 3 -- 신청일자 THEN
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
	END IF;
	ELSIF SearchMode = 5 -- 전체 THEN
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
