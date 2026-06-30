-- ─── FUNCTION: schedule_getreservationsformecount21 ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getreservationsformecount21(character varying, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservationsformecount21(
    p_rsvnstatus character varying DEFAULT 'RW',
    p_searchmode integer DEFAULT 0,
    p_searchtext character varying DEFAULT '',
    p_searchtext1 character varying DEFAULT '',
    p_searchtext2 character varying DEFAULT ''
) RETURNS TABLE(
    rsvnstatus text,
    reason text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	if(P_SearchText1 != '' and P_SearchText2 != '' )
	begin
		set DateNull = 1
	end

	RAISE NOTICE '%', 'P_RsvnStatus=' || P_RsvnStatus;
	RAISE NOTICE '%', 'P_SearchMode=' || CONVERT(NVARCHAR,P_SearchMode);
	IF P_SearchMode = 0 -- 전체
	BEGIN
		RAISE NOTICE '%', 0;
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				RR.RsvnStatus,
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			--WHERE 1=1 --R.IsReservation = TRUE 
			WHERE RR.RegUserNo = P_UserNo
			--AND (RsvnStatus = P_RsvnStatus OR RsvnStatus = 'RW')
			AND RsvnStatus = schedule_getreservationsformecount21.p_rsvnstatus
			AND 
			(
				R.Name ILIKE '%' || P_SearchText || '%' OR
				RR.Title ILIKE '%' || P_SearchText || '%'
			)
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
	END
	ELSE IF P_SearchMode = 1 -- 자원명
	BEGIN
		RAISE NOTICE '%', 1;
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				RR.RsvnStatus,
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			--WHERE 1=1 --R.IsReservation = TRUE 
			WHERE RR.RegUserNo = P_UserNo
			--AND (RsvnStatus = P_RsvnStatus OR RsvnStatus = 'RW')
			AND RsvnStatus = schedule_getreservationsformecount21.p_rsvnstatus
			AND R.Name ILIKE '%' || P_SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
				
		) A
	END
	ELSE IF P_SearchMode = 2 -- 예약제목
	BEGIN
		RAISE NOTICE '%', 2;
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				RR.RsvnStatus,
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			--WHERE 1=1 --R.IsReservation = TRUE 
			WHERE RR.RegUserNo = P_UserNo
			--AND (RsvnStatus = P_RsvnStatus OR RsvnStatus = 'RW')
			AND RsvnStatus = schedule_getreservationsformecount21.p_rsvnstatus
			AND RR.Title ILIKE '%' || P_SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
	END
	ELSE IF P_SearchMode = 3 -- 신청일자
	BEGIN
		RAISE NOTICE '%', 3;
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				RR.RsvnStatus,
				RR.Reason
			FROM ScheduleResourceReservations RR
			LEFT JOIN ScheduleResources R ON RR.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
			WHERE 1=1--R.IsReservation = TRUE 
			AND RR.RegUserNo = P_UserNo
			AND (RsvnStatus = schedule_getreservationsformecount21.p_rsvnstatus OR RsvnStatus = 'RW')
			AND RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))
		) A
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
