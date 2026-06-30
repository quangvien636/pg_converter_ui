-- ─── FUNCTION: schedule_getresourcessearchcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcessearchcount(integer, character varying, boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcessearchcount(
    userno integer,
    searchtext character varying DEFAULT '',
    isadmin boolean DEFAULT FALSE
) RETURNS TABLE(
    rownum text,
    reservationno text,
    name text,
    title text,
    reguserno text,
    regusername text,
    startdate text,
    enddate text,
    starttime text,
    endtime text,
    regdate text,
    rsvnstatus text,
    col13 text
)
AS $function$
BEGIN


	IF SearchMode = 0 -- 전체 검색
	BEGIN
		-- 전체 자원 예약
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
				RR.ReservationNo,
				RR.StartDate,
				RR.EndDate,
				DATEDIFF(D,RR.StartDate,RR.EndDate)+1 As DayCount,
				RR.StartTime,
				RR.EndTime,
				R.Name,
				RR.Title,
				RR.RegUserNo,
				public."COMNGetUserName"(RR.RegUserNo) AS RegUserName
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
			WHERE 
			(	
				Name ILIKE '%' || SearchText || '%' OR 
				Title ILIKE '%' || SearchText || '%' OR
				public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
			)
		) A
		-- 내 자원예약

		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
				R.Name,
				RR.Title,
				RR.ReservationNo,
				RR.RegDate,
				RR.StartDate,
				RR.EndDate,
				RR.StartTime,
				RR.EndTime,
				RR.RsvnStatus,
				CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
					 WHEN RR.RsvnStatus = 'RA' THEN '승인'
					 WHEN RR.RsvnStatus = 'RR' THEN '반려'
				END RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
			WHERE 
			(	
				Name ILIKE '%' || SearchText || '%' OR 
				Title ILIKE '%' || SearchText || '%' OR
				public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
			)
			AND RR.RegUserNo = schedule_getresourcessearchcount.userno
			AND R.IsReservation = TRUE
		) A
		
		IF IsAdmin = TRUE
		BEGIN
			-- 사용중인 자원
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
					R.ResourceNo,
					R.Name,
					RR.RegUserNo,
					public."COMNGetUserName"(RR.RegUserNo) As RegUserName,
					RR.Title
				FROM ScheduleResourceReservations RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				WHERE 
				(	
					Name ILIKE '%' || SearchText || '%' OR 
					Title ILIKE '%' || SearchText || '%' OR
					public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
				)
				AND RR.RegUserNo = schedule_getresourcessearchcount.userno
				AND NOW() BETWEEN RR.StartDate AND RR.EndDate -- 사용중인 자원을 표시해야 되기 때문에 날짜 제한.
			) A
			  
			-- 수리 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY RR.RepairNo) As RowNum,
					RR.RepairNo,
					RR.ResourceNo,
					R.Name,
					RR.Amount,
					RR.CompanyName,
					RR.StartDate,
					RR.LastUserNo,
					public."COMNGetUserName"(RR.LastUserNo) AS LastUserName,
					RR.Reason
				FROM ScheduleResourcesRepair RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				WHERE 
				(	
					Name ILIKE '%' || SearchText || '%' OR 
					CompanyName ILIKE '%' || SearchText || '%' OR
					public."COMNGetUserName"(RR.LastUserNo) ILIKE '%' || SearchText || '%' OR
					public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%' 
				)
			) A

			-- 폐기 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY RD.DisposeNo) As RowNum,
					RD.DisposeNo,
					R.ResourceNo,
					R.Name,
					B.CompanyName,
					RD.DisposeDate,
					RD.DisposeReason
				FROM ScheduleResourcesDispose RD
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RD.ResourceNo
				LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
				WHERE 
				(
					R.Name ILIKE '%' || SearchText || '%' OR 
					B.CompanyName ILIKE '%' || SearchText || '%' OR
					public."COMNGetUserName"(RD.RegUserNo) ILIKE '%' || SearchText || '%' 
				)
			) A
			
			-- 예약 요청 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) As RowNum,
					RR.ReservationNo,
					R.Name,
					RR.Title,
					RR.RegUserNo,
					public."COMNGetUserName"(RR.RegUserNo) AS RegUserName,
					RR.StartDate,
					RR.EndDate,
					RR.StartTime,
					RR.EndTime,
					RR.RegDate,
					RR.RsvnStatus,
					CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
						 WHEN RR.RsvnStatus = 'RA' THEN '승인'
						 WHEN RR.RsvnStatus = 'RR' THEN '반려'
					END RsvnStatusDesc
				FROM ScheduleResourceReservations RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
				WHERE (IsAdmin = TRUE OR B.MainManagerNo = schedule_getresourcessearchcount.userno OR B.SubManagerNo = schedule_getresourcessearchcount.userno)
				AND 
				(
					R.Name ILIKE '%' || SearchText || '%' OR
					RR.Title ILIKE '%' || SearchText || '%' OR
					B.CompanyName ILIKE '%' || SearchText || '%' OR
					public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%' 
				)
			) A
			
		END
	END
	ELSE IF SearchMode = 1 -- 자원명
	BEGIN
		-- 전체 자원 예약
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
				RR.ReservationNo,
				RR.StartDate,
				RR.EndDate,
				DATEDIFF(D,RR.StartDate,RR.EndDate)+1 As DayCount,
				RR.StartTime,
				RR.EndTime,
				R.Name,
				RR.Title,
				RR.RegUserNo,
				public."COMNGetUserName"(RR.RegUserNo) AS RegUserName
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
			WHERE 
			(	
				Name ILIKE '%' || SearchText || '%'
			)
		) A 
		-- 내 자원예약

		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
				R.Name,
				RR.Title,
				RR.ReservationNo,
				RR.RegDate,
				RR.StartDate,
				RR.EndDate,
				RR.StartTime,
				RR.EndTime,
				RR.RsvnStatus,
				CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
					 WHEN RR.RsvnStatus = 'RA' THEN '승인'
					 WHEN RR.RsvnStatus = 'RR' THEN '반려'
				END RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
			WHERE 
			(	
				Name ILIKE '%' || SearchText || '%'
			)
			AND RR.RegUserNo = schedule_getresourcessearchcount.userno
			AND R.IsReservation = TRUE
		) A
		
		IF IsAdmin = TRUE
		BEGIN
			-- 사용중인 자원
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
					R.ResourceNo,
					R.Name,
					RR.RegUserNo,
					public."COMNGetUserName"(RR.RegUserNo) As RegUserName,
					RR.Title
				FROM ScheduleResourceReservations RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				WHERE 
				(	
					Name ILIKE '%' || SearchText || '%'
				)
				AND RR.RegUserNo = schedule_getresourcessearchcount.userno
				AND NOW() BETWEEN RR.StartDate AND RR.EndDate -- 사용중인 자원을 표시해야 되기 때문에 날짜 제한.
			) A
			  
			-- 수리 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY RR.RepairNo) As RowNum,
					RR.RepairNo,
					RR.ResourceNo,
					R.Name,
					RR.Amount,
					RR.CompanyName,
					RR.StartDate,
					RR.LastUserNo,
					public."COMNGetUserName"(RR.LastUserNo) AS LastUserName,
					RR.Reason
				FROM ScheduleResourcesRepair RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				WHERE 
				(	
					Name ILIKE '%' || SearchText || '%'
				)
			) A 

			-- 폐기 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY RD.DisposeNo) As RowNum,
					RD.DisposeNo,
					R.ResourceNo,
					R.Name,
					B.CompanyName,
					RD.DisposeDate,
					RD.DisposeReason
				FROM ScheduleResourcesDispose RD
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RD.ResourceNo
				LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
				WHERE 
				(
					R.Name ILIKE '%' || SearchText || '%'
				)
			) A
			
			-- 예약 요청 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) As RowNum,
					RR.ReservationNo,
					R.Name,
					RR.Title,
					RR.RegUserNo,
					public."COMNGetUserName"(RR.RegUserNo) AS RegUserName,
					RR.StartDate,
					RR.EndDate,
					RR.StartTime,
					RR.EndTime,
					RR.RegDate,
					RR.RsvnStatus,
					CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
						 WHEN RR.RsvnStatus = 'RA' THEN '승인'
						 WHEN RR.RsvnStatus = 'RR' THEN '반려'
					END RsvnStatusDesc
				FROM ScheduleResourceReservations RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
				WHERE (IsAdmin = TRUE OR B.MainManagerNo = schedule_getresourcessearchcount.userno OR B.SubManagerNo = schedule_getresourcessearchcount.userno)
				AND 
				(
					R.Name ILIKE '%' || SearchText || '%'
				)
			) A
			
		END
	END 
	ELSE IF SearchMode = 2 -- 작성자
	BEGIN
		
		-- 전체 자원 예약
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
				RR.ReservationNo,
				RR.StartDate,
				RR.EndDate,
				DATEDIFF(D,RR.StartDate,RR.EndDate)+1 As DayCount,
				RR.StartTime,
				RR.EndTime,
				R.Name,
				RR.Title,
				RR.RegUserNo,
				public."COMNGetUserName"(RR.RegUserNo) AS RegUserName
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
			WHERE 
			(	
				public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
			)
		) A
		
		-- 내 자원예약

		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
				R.Name,
				RR.Title,
				RR.ReservationNo,
				RR.RegDate,
				RR.StartDate,
				RR.EndDate,
				RR.StartTime,
				RR.EndTime,
				RR.RsvnStatus,
				CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
					 WHEN RR.RsvnStatus = 'RA' THEN '승인'
					 WHEN RR.RsvnStatus = 'RR' THEN '반려'
				END RsvnStatusDesc
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
			WHERE 
			(	
				public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
			)
			AND RR.RegUserNo = schedule_getresourcessearchcount.userno
			AND R.IsReservation = TRUE
		) A
		
		IF IsAdmin = TRUE
		BEGIN
			-- 사용중인 자원
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
					R.ResourceNo,
					R.Name,
					RR.RegUserNo,
					public."COMNGetUserName"(RR.RegUserNo) As RegUserName,
					RR.Title
				FROM ScheduleResourceReservations RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				WHERE 
				(	
					public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
				)
				AND RR.RegUserNo = schedule_getresourcessearchcount.userno
				AND NOW() BETWEEN RR.StartDate AND RR.EndDate -- 사용중인 자원을 표시해야 되기 때문에 날짜 제한.
			) A
			
			-- 수리 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY RR.RepairNo) As RowNum,
					RR.RepairNo,
					RR.ResourceNo,
					R.Name,
					RR.Amount,
					RR.CompanyName,
					RR.StartDate,
					RR.LastUserNo,
					public."COMNGetUserName"(RR.LastUserNo) AS LastUserName,
					RR.Reason
				FROM ScheduleResourcesRepair RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				WHERE public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
			) A

			-- 폐기 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY RD.DisposeNo) As RowNum,
					RD.DisposeNo,
					R.ResourceNo,
					R.Name,
					B.CompanyName,
					RD.DisposeDate,
					RD.DisposeReason
				FROM ScheduleResourcesDispose RD
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RD.ResourceNo
				LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
				WHERE public."COMNGetUserName"(RD.RegUserNo) ILIKE '%' || SearchText || '%'
			) A
			
			-- 예약 요청 목록
			RETURN QUERY
			SELECT
				COUNT(*) AS CNT
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) As RowNum,
					RR.ReservationNo,
					R.Name,
					RR.Title,
					RR.RegUserNo,
					public."COMNGetUserName"(RR.RegUserNo) AS RegUserName,
					RR.StartDate,
					RR.EndDate,
					RR.StartTime,
					RR.EndTime,
					RR.RegDate,
					RR.RsvnStatus,
					CASE WHEN RR.RsvnStatus = 'RW' THEN '대기중'
						 WHEN RR.RsvnStatus = 'RA' THEN '승인'
						 WHEN RR.RsvnStatus = 'RR' THEN '반려'
					END RsvnStatusDesc
				FROM ScheduleResourceReservations RR
				LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
				LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
				WHERE (IsAdmin = TRUE OR B.MainManagerNo = schedule_getresourcessearchcount.userno OR B.SubManagerNo = schedule_getresourcessearchcount.userno)
				AND 
				(
					public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
				)
			) A
		END
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
