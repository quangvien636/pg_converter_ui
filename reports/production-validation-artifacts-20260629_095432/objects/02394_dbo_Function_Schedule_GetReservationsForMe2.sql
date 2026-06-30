-- ─── FUNCTION: schedule_getreservationsforme2 ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservationsforme2(character varying, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservationsforme2(
    p_rsvnstatus character varying DEFAULT 'RW',
    p_pagesize integer DEFAULT 10,
    p_currpage integer DEFAULT 1,
    p_searchmode integer DEFAULT 0,
    p_searchtext character varying DEFAULT '',
    p_searchtext1 character varying DEFAULT '',
    p_searchtext2 character varying DEFAULT ''
) RETURNS TABLE(
    departno text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	if(P_SearchText1 != '' and P_SearchText2 != '' )
	begin
		set DateNull = 1
	end

	IF P_SearchMode = 0 -- 전체
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
				RR.ProcessDate,
				RR.ProcessUserNo,
				public."COMNGetUserName"(RR.ProcessUserNo) As ProcessUserName,
				RR.Reason,
				-- 참여자 수
				CASE
					-- 참여자 수가 없는 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) = 0 THEN 0 
					-- 사용자 별 참여인 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo AND P.UserNo > 0) >= 1 THEN
						(SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo)
					-- 부서별 참여인 경우
					ELSE (
							SELECT COUNT(B.UserNo) AS UserCnt
							FROM Organization_BelongToDepartment B
							INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
							INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
							WHERE DepartNo IN (SELECT DepartNo FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) AND U.Enabled = TRUE)
				END AS PartCount,
				RR.UserView
				,COALESCE( R.IsHidenReg,0) IsHidenReg
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			--WHERE R.IsReservation = TRUE
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsforme2.p_rsvnstatus or RsvnStatus = schedule_getreservationsforme2.p_rsvnstatus)
			AND 
			(
				R.Name ILIKE '%' || P_SearchText || '%' OR
				RR.Title ILIKE '%' || P_SearchText || '%'
			)
			--AND RR.UserView = 0
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
		WHERE RowNum BETWEEN ((P_CurrPage-1) * P_PageSize + 1) AND (P_CurrPage * P_PageSize)
	END
	ELSE IF P_SearchMode = 1 -- 자원명
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
				RR.ProcessDate,
				RR.ProcessUserNo,
				public."COMNGetUserName"(RR.ProcessUserNo) As ProcessUserName,
				RR.Reason,
				-- 참여자 수
				CASE
					-- 참여자 수가 없는 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) = 0 THEN 0 
					-- 사용자 별 참여인 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo AND P.UserNo > 0) >= 1 THEN
						(SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo)
					-- 부서별 참여인 경우
					ELSE (
							SELECT COUNT(B.UserNo) AS UserCnt
							FROM Organization_BelongToDepartment B
							INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
							INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
							WHERE DepartNo IN (SELECT DepartNo FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) AND U.Enabled = TRUE)
				END AS PartCount,
				RR.UserView
				,COALESCE( R.IsHidenReg,0) IsHidenReg
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			--WHERE R.IsReservation = TRUE
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsforme2.p_rsvnstatus or RsvnStatus = schedule_getreservationsforme2.p_rsvnstatus)
			AND R.Name ILIKE '%' || P_SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))

		) A
		WHERE RowNum BETWEEN ((P_CurrPage-1) * P_PageSize + 1) AND (P_CurrPage * P_PageSize)
	END
	ELSE IF P_SearchMode = 2 -- 예약제목
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
				RR.ProcessDate,
				RR.ProcessUserNo,
				public."COMNGetUserName"(RR.ProcessUserNo) As ProcessUserName,
				RR.Reason,
				-- 참여자 수
				CASE
					-- 참여자 수가 없는 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) = 0 THEN 0 
					-- 사용자 별 참여인 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo AND P.UserNo > 0) >= 1 THEN
						(SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo)
					-- 부서별 참여인 경우
					ELSE (
							SELECT COUNT(B.UserNo) AS UserCnt
							FROM Organization_BelongToDepartment B
							INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
							INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
							WHERE DepartNo IN (SELECT DepartNo FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) AND U.Enabled = TRUE)
				END AS PartCount,
				RR.UserView
				,COALESCE( R.IsHidenReg,0) IsHidenReg
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			--WHERE R.IsReservation = TRUE
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsforme2.p_rsvnstatus or RsvnStatus = schedule_getreservationsforme2.p_rsvnstatus)
			AND RR.Title ILIKE '%' || P_SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
		WHERE RowNum BETWEEN ((P_CurrPage-1) * P_PageSize + 1) AND (P_CurrPage * P_PageSize)
	END
	ELSE IF P_SearchMode = 3 -- 신청일자
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
				RR.ProcessDate,
				RR.ProcessUserNo,
				public."COMNGetUserName"(RR.ProcessUserNo) As ProcessUserName,
				RR.Reason,
				-- 참여자 수
				CASE
					-- 참여자 수가 없는 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) = 0 THEN 0 
					-- 사용자 별 참여인 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo AND P.UserNo > 0) >= 1 THEN
						(SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo)
					-- 부서별 참여인 경우
					ELSE (
							SELECT COUNT(B.UserNo) AS UserCnt
							FROM Organization_BelongToDepartment B
							INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
							INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
							WHERE DepartNo IN (SELECT DepartNo FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) AND U.Enabled = TRUE)
				END AS PartCount,
				RR.UserView
				,COALESCE( R.IsHidenReg,0) IsHidenReg
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			--WHERE R.IsReservation = TRUE
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsforme2.p_rsvnstatus or RsvnStatus = schedule_getreservationsforme2.p_rsvnstatus)
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
		WHERE RowNum BETWEEN ((P_CurrPage-1) * P_PageSize + 1) AND (P_CurrPage * P_PageSize)
	END

	ELSE IF P_SearchMode = 4 -- 신청일자
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
				RR.ProcessDate,
				RR.ProcessUserNo,
				public."COMNGetUserName"(RR.ProcessUserNo) As ProcessUserName,
				RR.Reason,
				-- 참여자 수
				CASE
					-- 참여자 수가 없는 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) = 0 THEN 0 
					-- 사용자 별 참여인 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo AND P.UserNo > 0) >= 1 THEN
						(SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo)
					-- 부서별 참여인 경우
					ELSE (
							SELECT COUNT(B.UserNo) AS UserCnt
							FROM Organization_BelongToDepartment B
							INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
							INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
							WHERE DepartNo IN (SELECT DepartNo FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) AND U.Enabled = TRUE)
				END AS PartCount,
				RR.UserView
				,COALESCE( R.IsHidenReg,0) IsHidenReg
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			LEFT JOIN Organization_Users U ON RR.RegUserNo = U.UserNo
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsforme2.p_rsvnstatus or RsvnStatus = schedule_getreservationsforme2.p_rsvnstatus)
			AND LOWER(U.Name) ILIKE '%' || LOWER(P_SearchText) + '%'
		) A
		WHERE RowNum BETWEEN ((P_CurrPage-1) * P_PageSize + 1) AND (P_CurrPage * P_PageSize)
	END

	ELSE IF P_SearchMode = 5 -- 전체
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
				RR.ProcessDate,
				RR.ProcessUserNo,
				public."COMNGetUserName"(RR.ProcessUserNo) As ProcessUserName,
				RR.Reason,
				-- 참여자 수
				CASE
					-- 참여자 수가 없는 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) = 0 THEN 0 
					-- 사용자 별 참여인 경우 
					WHEN (SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo AND P.UserNo > 0) >= 1 THEN
						(SELECT COUNT(UserNo) FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo)
					-- 부서별 참여인 경우
					ELSE (
							SELECT COUNT(B.UserNo) AS UserCnt
							FROM Organization_BelongToDepartment B
							INNER JOIN Organization_Users U ON U.UserNo = B.UserNo
							INNER JOIN Organization_Positions P ON P.PositionNo = B.PositionNo
							WHERE DepartNo IN (SELECT DepartNo FROM ScheduleResourceParticipants P WHERE P.ReservationNo = RR.ReservationNo) AND U.Enabled = TRUE)
				END AS PartCount,
				RR.UserView
				,COALESCE( R.IsHidenReg,0) IsHidenReg
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsforme2.p_rsvnstatus or RsvnStatus = schedule_getreservationsforme2.p_rsvnstatus)
			AND (DateNull = 0 or (RR.StartDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
		WHERE RowNum BETWEEN ((P_CurrPage-1) * P_PageSize + 1) AND (P_CurrPage * P_PageSize)
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
