-- ─── PROCEDURE→FUNCTION: schedule_getresourceforusedetaillistcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourceforusedetaillistcount(date);
CREATE OR REPLACE FUNCTION public.schedule_getresourceforusedetaillistcount(
    IN seldate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

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
			RR.Title,
			RR.StartDate,
			RR.StartTime,
			RR.EndDate,
			RR.EndTime
		FROM ScheduleResourceReservations RR
		LEFT JOIN ScheduleResources R ON R.ResourceNo  = RR.ResourceNo
		WHERE R.BuyGroupNo = BuyGroupNo
		AND SelDate BETWEEN RR.StartDate AND RR.EndDate
	) A;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
