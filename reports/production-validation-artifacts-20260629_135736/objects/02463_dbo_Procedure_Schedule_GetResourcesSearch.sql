-- ─── PROCEDURE→FUNCTION: schedule_getresourcessearch ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcessearch(integer, character varying, boolean, integer, integer, integer, integer, integer, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourcessearch(
    IN userno integer,
    IN searchtext character varying DEFAULT '',
    IN isadmin boolean DEFAULT FALSE,
    IN pagesize integer DEFAULT 10,
    IN allrsvncurrpage integer DEFAULT 1,
    IN myrsvncurrpage integer DEFAULT 1,
    IN usecurrpage integer DEFAULT 1,
    IN repaircurrpage integer DEFAULT 1,
    IN disposecurrpage integer DEFAULT 1,
    IN reqcurrpage integer DEFAULT 1
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SearchMode = 0 -- 전체 검색 THEN
		-- 전체 자원 예약
		RETURN QUERY
		SELECT
			*
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
		WHERE RowNum BETWEEN ((AllRsvnCurrPage-1) * PageSize + 1) AND (AllRsvnCurrPage * PageSize)  
		-- 내 자원예약

		RETURN QUERY
		SELECT
			*
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
			AND RR.RegUserNo = schedule_getresourcessearch.userno
			AND R.IsReservation = TRUE
		) A
		WHERE RowNum BETWEEN ((MyRsvnCurrPage-1) * PageSize + 1) AND (MyRsvnCurrPage * PageSize)  
		IF IsAdmin = TRUE THEN
			-- 사용중인 자원
			RETURN QUERY
			SELECT
				*
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
					RR.ReservationNo,
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
				AND RR.RegUserNo = schedule_getresourcessearch.userno
				AND CONVERT(DATE,NOW()) BETWEEN RR.StartDate AND RR.EndDate -- 사용중인 자원을 표시해야 되기 때문에 날짜 제한.
			) A
			WHERE RowNum BETWEEN ((UseCurrPage-1) * PageSize + 1) AND (UseCurrPage * PageSize)  
			-- 수리 목록
			RETURN QUERY
			SELECT
				*
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
			WHERE RowNum BETWEEN ((RepairCurrPage-1) * PageSize + 1) AND (RepairCurrPage * PageSize)  

			-- 폐기 목록
			RETURN QUERY
			SELECT
				*
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
			WHERE RowNum BETWEEN ((DisposeCurrPage-1) * PageSize + 1) AND (DisposeCurrPage * PageSize)  
			-- 예약 요청 목록
			RETURN QUERY
			SELECT
				*
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) As RowNum,
					RR.ReservationNo,
					RR.ResourceNo,
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
				WHERE (IsAdmin = TRUE OR B.MainManagerNo = schedule_getresourcessearch.userno OR B.SubManagerNo = schedule_getresourcessearch.userno)
				AND 
				(
					R.Name ILIKE '%' || SearchText || '%' OR
					RR.Title ILIKE '%' || SearchText || '%' OR
					B.CompanyName ILIKE '%' || SearchText || '%' OR
					public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%' 
				)
			) A
			WHERE RowNum BETWEEN ((ReqCurrPage-1) * PageSize + 1) AND (ReqCurrPage * PageSize)  
		END IF;
	END IF;
	ELSIF SearchMode = 1 -- 자원명 THEN
		-- 전체 자원 예약
		RETURN QUERY
		SELECT
			*
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
		WHERE RowNum BETWEEN ((AllRsvnCurrPage-1) * PageSize + 1) AND (AllRsvnCurrPage * PageSize)  
		-- 내 자원예약

		RETURN QUERY
		SELECT
			*
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
			AND RR.RegUserNo = schedule_getresourcessearch.userno
			AND R.IsReservation = TRUE
		) A
		WHERE RowNum BETWEEN ((MyRsvnCurrPage-1) * PageSize + 1) AND (MyRsvnCurrPage * PageSize)  
		IF IsAdmin = TRUE THEN
			-- 사용중인 자원
			RETURN QUERY
			SELECT
				*
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
					RR.ReservationNo,
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
				AND RR.RegUserNo = schedule_getresourcessearch.userno
				AND CONVERT(DATE,NOW()) BETWEEN RR.StartDate AND RR.EndDate -- 사용중인 자원을 표시해야 되기 때문에 날짜 제한.
			) A
			WHERE RowNum BETWEEN ((UseCurrPage-1) * PageSize + 1) AND (UseCurrPage * PageSize)  
			-- 수리 목록
			RETURN QUERY
			SELECT
				*
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
			WHERE RowNum BETWEEN ((RepairCurrPage-1) * PageSize + 1) AND (RepairCurrPage * PageSize)  

			-- 폐기 목록
			RETURN QUERY
			SELECT
				*
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
			WHERE RowNum BETWEEN ((DisposeCurrPage-1) * PageSize + 1) AND (DisposeCurrPage * PageSize)  
			-- 예약 요청 목록
			RETURN QUERY
			SELECT
				*
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) As RowNum,
					RR.ReservationNo,
					RR.ResourceNo,
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
				WHERE (IsAdmin = TRUE OR B.MainManagerNo = schedule_getresourcessearch.userno OR B.SubManagerNo = schedule_getresourcessearch.userno)
				AND 
				(
					R.Name ILIKE '%' || SearchText || '%'
				)
			) A
			WHERE RowNum BETWEEN ((ReqCurrPage-1) * PageSize + 1) AND (ReqCurrPage * PageSize)  
		END IF;
	END IF;
	ELSIF SearchMode = 2 -- 작성자 THEN
		
		-- 전체 자원 예약
		RETURN QUERY
		SELECT
			*
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
		WHERE RowNum BETWEEN ((AllRsvnCurrPage-1) * PageSize + 1) AND (AllRsvnCurrPage * PageSize)  
		-- 내 자원예약

		RETURN QUERY
		SELECT
			*
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
			AND RR.RegUserNo = schedule_getresourcessearch.userno
			AND R.IsReservation = TRUE
		) A
		WHERE RowNum BETWEEN ((MyRsvnCurrPage-1) * PageSize + 1) AND (MyRsvnCurrPage * PageSize)  
		IF IsAdmin = TRUE THEN
			-- 사용중인 자원
			RETURN QUERY
			SELECT
				*
			FROM
			(
				SELECT 
					ROW_NUMBER() OVER(ORDER BY StartDate DESC,EndDate DESC) As RowNum,
					RR.ReservationNo,
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
				AND RR.RegUserNo = schedule_getresourcessearch.userno
				AND CONVERT(DATE,NOW()) BETWEEN RR.StartDate AND RR.EndDate -- 사용중인 자원을 표시해야 되기 때문에 날짜 제한.
			) A
			WHERE RowNum BETWEEN ((UseCurrPage-1) * PageSize + 1) AND (UseCurrPage * PageSize)  
			-- 수리 목록
			RETURN QUERY
			SELECT
				*
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
			WHERE RowNum BETWEEN ((RepairCurrPage-1) * PageSize + 1) AND (RepairCurrPage * PageSize)  

			-- 폐기 목록
			RETURN QUERY
			SELECT
				*
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
			WHERE RowNum BETWEEN ((DisposeCurrPage-1) * PageSize + 1) AND (DisposeCurrPage * PageSize)  
			-- 예약 요청 목록
			RETURN QUERY
			SELECT
				*
			FROM
			(
				SELECT
					ROW_NUMBER() OVER(ORDER BY RR.ReservationNo DESC) As RowNum,
					RR.ReservationNo,
					RR.ResourceNo,
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
				WHERE (IsAdmin = TRUE OR B.MainManagerNo = schedule_getresourcessearch.userno OR B.SubManagerNo = schedule_getresourcessearch.userno)
				AND 
				(
					public."COMNGetUserName"(RR.RegUserNo) ILIKE '%' || SearchText || '%'
				)
			) A
			WHERE RowNum BETWEEN ((ReqCurrPage-1) * PageSize + 1) AND (ReqCurrPage * PageSize)  
		END IF;
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
