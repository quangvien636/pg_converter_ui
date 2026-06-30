-- ─── PROCEDURE→FUNCTION: schedule_getreservationleftcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getreservationleftcount(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getreservationleftcount(
    IN isadmin boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN






	SELECT  INTO  FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	and RsvnStatus = 'RA'
	AND R.IsReservation = FALSE
	GROUP BY RsvnStatus

	SELECT  INTO  FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	and RsvnStatus = 'RW'
	AND R.IsReservation = FALSE
	GROUP BY RsvnStatus

	SELECT  INTO  FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	and RsvnStatus = 'RR'
	AND R.IsReservation = FALSE
	GROUP BY RsvnStatus

	SELECT  INTO  FROM ScheduleResourceReservations RR
	LEFT JOIN ScheduleResources R ON R.ResourceNo = RR.ResourceNo
	LEFT JOIN ScheduleResourcesBuyGroup B ON B.BuyGroupNo = R.BuyGroupNo
	WHERE (IsAdmin = TRUE OR B.MainManagerNo = UserNo OR B.SubManagerNo = UserNo)
	AND RR.ProcessView = 0
	AND R.IsReservation = FALSE
	--GROUP BY RsvnStatus

	RETURN QUERY
	select A_CNT as A_CNT, W_CNT as W_CNT, R_CNT as R_CNT, All_CNT as All_CNT;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
