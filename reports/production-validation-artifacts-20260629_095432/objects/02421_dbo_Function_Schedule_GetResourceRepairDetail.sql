-- ─── FUNCTION: schedule_getresourcerepairdetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairdetail(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairdetail(
    otherhistory boolean DEFAULT 0 -- 이전 히스토리도 같이보기
) RETURNS TABLE(
    repairno text,
    resourceno text,
    resourcename text,
    categoryname text,
    lastuserno text,
    lastusername text,
    companyname text,
    amount text,
    startdate text,
    enddate text,
    reason text,
    status text
)
AS $function$
BEGIN

	
	IF OtherHistory = 0 
	BEGIN
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
	END
	ELSE
	BEGIN

		
		SELECT ResourceNo = ResourceNo FROM ScheduleResourcesRepair WHERE RepairNo = RepairNo
		
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
