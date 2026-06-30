-- ─── PROCEDURE→FUNCTION: schedule_getresourcerepairdetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairdetail(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairdetail(
    IN otherhistory boolean DEFAULT 0 -- 이전 히스토리도 같이보기
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	IF OtherHistory = 0 THEN
		RETURN QUERY
		SELECT
			P.RepairNo,
			P.ResourceNo,
			R.Name As ResourceName,
			C.Name AS CategoryName,
			P.LastUserNo,
			public."COMNGetUserName"(P.LastUserNo) As LastUserName,
			P.CompanyName,
			P.Amount,
			P.StartDate,
			P.EndDate,
			P.Reason,
			P.Status
		FROM
			ScheduleResourcesRepair P
			LEFT JOIN ScheduleResources R ON R.ResourceNo = P.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
		WHERE RepairNo = RepairNo
	END IF;
	ELSE

		
		SELECT ResourceNo INTO resourceno FROM ScheduleResourcesRepair WHERE RepairNo = RepairNo
		
		RETURN QUERY
		SELECT
			P.RepairNo,
			P.ResourceNo,
			R.Name As ResourceName,
			C.Name AS CategoryName,
			P.LastUserNo,
			public."COMNGetUserName"(P.LastUserNo) As LastUserName,
			P.CompanyName,
			P.Amount,
			P.StartDate,
			P.EndDate,
			P.Reason,
			P.Status
		FROM
			ScheduleResourcesRepair P
			LEFT JOIN ScheduleResources R ON R.ResourceNo = P.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
		WHERE RepairNo = RepairNo
		UNION ALL
		RETURN QUERY
		SELECT
			P.RepairNo,
			P.ResourceNo,
			R.Name As ResourceName,
			C.Name AS CategoryName,
			P.LastUserNo,
			public."COMNGetUserName"(P.LastUserNo) As LastUserName,
			P.CompanyName,
			P.Amount,
			P.StartDate,
			P.EndDate,
			P.Reason,
			P.Status
		FROM
			ScheduleResourcesRepair P
			LEFT JOIN ScheduleResources R ON R.ResourceNo = P.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
		WHERE RepairNo <> RepairNo 
		AND P.ResourceNo = ResourceNo
		ORDER BY P.StartDate DESC
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
