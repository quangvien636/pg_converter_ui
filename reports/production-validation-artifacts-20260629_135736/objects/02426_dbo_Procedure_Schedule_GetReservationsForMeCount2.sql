-- ─── PROCEDURE→FUNCTION: schedule_getreservationsformecount2 ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.schedule_getreservationsformecount2(character varying, integer, character varying, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getreservationsformecount2(
    IN p_rsvnstatus character varying DEFAULT 'RW',
    IN p_searchmode integer DEFAULT 0,
    IN p_searchtext character varying DEFAULT '',
    IN p_searchtext1 character varying DEFAULT '',
    IN p_searchtext2 character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	if(P_SearchText1 != '' and P_SearchText2 != '' )
	begin
		DateNull := 1;
	END;

	--PRINT 'P_RsvnStatus=' || P_RsvnStatus;
	--PRINT 'P_SearchMode=' || CONVERT(NVARCHAR,P_SearchMode);
	IF P_SearchMode = 0 -- 전체 THEN
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
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsformecount2.p_rsvnstatus or RsvnStatus = schedule_getreservationsformecount2.p_rsvnstatus)
			AND 
			(
				R.Name ILIKE '%' || P_SearchText || '%' OR
				RR.Title ILIKE '%' || P_SearchText || '%'
			)
			--AND RR.UserView = 0
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
	END IF;
	ELSIF P_SearchMode = 1 -- 자원명 THEN
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
			AND (  'RAll' = schedule_getreservationsformecount2.p_rsvnstatus or RsvnStatus = schedule_getreservationsformecount2.p_rsvnstatus)
			AND R.Name ILIKE '%' || P_SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
				
		) A
	END IF;
	ELSIF P_SearchMode = 2 -- 예약제목 THEN
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
			AND (  'RAll' = schedule_getreservationsformecount2.p_rsvnstatus or RsvnStatus = schedule_getreservationsformecount2.p_rsvnstatus)
			AND RR.Title ILIKE '%' || P_SearchText || '%'
			AND (DateNull = 0 or (RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
	END IF;
	ELSIF P_SearchMode = 3 -- 신청일자 THEN
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
			AND (  'RAll' = schedule_getreservationsformecount2.p_rsvnstatus or RsvnStatus = schedule_getreservationsformecount2.p_rsvnstatus)
			AND RR.RegDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))
		) A
	END IF;
	ELSIF P_SearchMode = 4 -- VITHV THEN
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
			LEFT JOIN Organization_Users U ON RR.RegUserNo = U.UserNo
			WHERE 1=1--R.IsReservation = TRUE 
			AND RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsformecount2.p_rsvnstatus or RsvnStatus = schedule_getreservationsformecount2.p_rsvnstatus)
			AND LOWER(U.Name) ILIKE '%' || LOWER(P_SearchText) + '%'
		) A
	END IF;
	ELSIF P_SearchMode = 5 -- 전체 THEN
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
			WHERE RR.RegUserNo = P_UserNo
			AND (  'RAll' = schedule_getreservationsformecount2.p_rsvnstatus or RsvnStatus = schedule_getreservationsformecount2.p_rsvnstatus)
			--AND	public."COMNGetUserName"(RR.RegUserNo)  ILIKE '%' || P_SearchText || '%'
			--AND RR.UserView = 0
			AND (DateNull = 0 or (RR.StartDate BETWEEN CONVERT(DATE,P_SearchText1) AND DATEADD(day, 1,CONVERT(DATE,P_SearchText2))))
		) A
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
