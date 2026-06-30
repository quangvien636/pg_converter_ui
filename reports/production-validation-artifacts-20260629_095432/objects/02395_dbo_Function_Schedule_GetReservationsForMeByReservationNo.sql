-- ─── FUNCTION: schedule_getreservationsformebyreservationno ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservationsformebyreservationno();
CREATE OR REPLACE FUNCTION public.schedule_getreservationsformebyreservationno(
) RETURNS TABLE(
    departno text
)
AS $function$
BEGIN

		RETURN QUERY
		select
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
	WHERE RR.ReservationNo = ReservationNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
