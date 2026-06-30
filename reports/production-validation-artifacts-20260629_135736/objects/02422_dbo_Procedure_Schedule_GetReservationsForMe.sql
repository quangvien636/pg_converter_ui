-- ─── PROCEDURE→FUNCTION: schedule_getreservationsforme ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.schedule_getreservationsforme(character varying, integer, integer, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservationsforme(
    IN rsvnstatus character varying DEFAULT 'RW',
    IN pagesize integer DEFAULT 10,
    IN currpage integer DEFAULT 1,
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
			WHERE RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsforme.rsvnstatus or RsvnStatus = schedule_getreservationsforme.rsvnstatus)
			AND 
			(
				R.Name ILIKE '%' || SearchText || '%' OR
				RR.Title ILIKE '%' || SearchText || '%'
			)
			--AND RR.UserView = 0
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,SearchText1) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))))
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
		ORDER BY StartDate 
	END IF;
	ELSIF SearchMode = 1 -- 자원명 THEN
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
			WHERE RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsforme.rsvnstatus or RsvnStatus = schedule_getreservationsforme.rsvnstatus)
			AND R.Name ILIKE '%' || SearchText || '%'
				
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END IF;
	ELSIF SearchMode = 2 -- 예약제목 THEN
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
			WHERE RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsforme.rsvnstatus or RsvnStatus = schedule_getreservationsforme.rsvnstatus)
			AND RR.Title ILIKE '%' || SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,SearchText1) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))))
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END IF;
	ELSIF SearchMode = 3 -- 신청일자 THEN
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
			WHERE R.IsReservation = TRUE 
			AND RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsforme.rsvnstatus or RsvnStatus = schedule_getreservationsforme.rsvnstatus)
			AND RR.RegDate BETWEEN CONVERT(DATE,SearchText) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,SearchText1) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))))
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
	END IF;
	ELSIF SearchMode = 5 -- 전체 THEN
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
			WHERE RR.RegUserNo = UserNo
			AND (  'RAll' = schedule_getreservationsforme.rsvnstatus or RsvnStatus = schedule_getreservationsforme.rsvnstatus)
			AND	public."COMNGetUserName"(RR.RegUserNo)  ILIKE '%' || SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,SearchText1) AND DATEADD(day, 1,CONVERT(DATE,SearchText2))))
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)
		ORDER BY StartDate 
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
