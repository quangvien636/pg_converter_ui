-- ─── PROCEDURE→FUNCTION: schedule_getreservationscount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getreservationscount(integer, character varying, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservationscount(
    IN userno integer,
    IN rsvnstatus character varying DEFAULT 'RW',
    IN searchmode integer DEFAULT 0,
    IN searchtext character varying DEFAULT '',
    IN searchtext2 character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

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
				END AS RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = FALSE
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservationscount.userno OR B.SubManagerNo = schedule_getreservationscount.userno)
			AND RsvnStatus = schedule_getreservationscount.rsvnstatus
			AND 
			(
				R.Name ILIKE '%' || SearchText || '%' OR
				RR.Title ILIKE '%' || SearchText || '%' OR
				public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
			)
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
				END AS RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE R.IsReservation = FALSE
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservationscount.userno OR B.SubManagerNo = schedule_getreservationscount.userno)
			AND RsvnStatus = schedule_getreservationscount.rsvnstatus
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
				END AS RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE  R.IsReservation = FALSE
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservationscount.userno OR B.SubManagerNo = schedule_getreservationscount.userno)
			AND RsvnStatus = schedule_getreservationscount.rsvnstatus
			AND RR.Title ILIKE '%' || SearchText || '%'
		) A
	END IF;
	ELSIF SearchMode = 3 -- 예약일 THEN
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
				RR.StartDate,
				RR.StartTime,
				RR.EndDate,
				RR.EndTime,
				RR.RegDate,
				RR.RsvnStatus,
				CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
					 WHEN RR.RsvnStatus = 'RA' THEN '승인'
					 WHEN RR.RsvnStatus = 'RR' THEN '반려'
				END AS RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE  R.IsReservation = FALSE
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservationscount.userno OR B.SubManagerNo = schedule_getreservationscount.userno)
			AND RsvnStatus = schedule_getreservationscount.rsvnstatus
			AND RR.RegDate BETWEEN CONVERT(DATE,SearchText) AND CONVERT(DATE,SearchText2)
		) A
	END IF;
	ELSIF SearchMode = 4 -- 예약자 THEN
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
				RR.StartDate,
				RR.StartTime,
				RR.EndDate,
				RR.EndTime,
				RR.RegDate,
				RR.RsvnStatus,
				CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
					 WHEN RR.RsvnStatus = 'RA' THEN '승인'
					 WHEN RR.RsvnStatus = 'RR' THEN '반려'
				END AS RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE  R.IsReservation = FALSE
			AND (IsAdmin = TRUE OR B.MainManagerNo = schedule_getreservationscount.userno OR B.SubManagerNo = schedule_getreservationscount.userno)
			AND RsvnStatus = schedule_getreservationscount.rsvnstatus
			AND public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
		) A
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
