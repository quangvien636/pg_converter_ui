-- ─── FUNCTION: schedule_getresourcerepairscount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairscount(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairscount(
    searchmode integer DEFAULT 0,
    searchtext2 character varying DEFAULT '',
    status character varying DEFAULT 'A'
) RETURNS TABLE(
    rownum text,
    repairno text,
    resourceno text,
    categoryname text,
    resourcename text,
    amount text,
    companyname text,
    startdate text,
    enddate text,
    lastuserno text,
    lastusername text,
    reason text
)
AS $function$
BEGIN

	-- SeachMode = 0 검색이 아닌경우
	IF SearchMode = 0
	BEGIN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT	
				ROW_NUMBER() OVER(ORDER BY P.RepairNo Desc) As RowNum,
				P.RepairNo,
				P.ResourceNo,
				C.Name AS CategoryName,
				R.Name AS ResourceName,
				P.Amount,
				P.CompanyName,
				P.StartDate,
				P.EndDate,
				P.LastUserNo,
				public."COMNGetUserName"(P.LastUserNo) AS LastUserName,
				P.Reason
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairscount.status)
			AND (
				R.Name ILIKE '%' || SearchText || '%' OR
			    P.CompanyName ILIKE '%' || SearchText || '%' OR
			    public."COMNGetUserName"(P.LastUserNo) ILIKE '%' || SearchText || '%' 
			)
		) A
	END
	ELSE IF SearchMode = 1 -- 자원명 검색인 경우
	BEGIN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT	
				ROW_NUMBER() OVER(ORDER BY P.RepairNo Desc) As RowNum,
				P.RepairNo,
				P.ResourceNo,
				C.Name AS CategoryName,
				R.Name AS ResourceName,
				P.Amount,
				P.CompanyName,
				P.StartDate,
				P.EndDate,
				P.LastUserNo,
				public."COMNGetUserName"(P.LastUserNo) AS LastUserName,
				P.Reason
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairscount.status)
			AND R.Name ILIKE '%' || SearchText || '%'
		) A
	END
	ELSE IF SearchMode = 2 -- 수리업체 검색인 경우
	BEGIN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT	
				ROW_NUMBER() OVER(ORDER BY P.RepairNo Desc) As RowNum,
				P.RepairNo,
				P.ResourceNo,
				C.Name AS CategoryName,
				R.Name AS ResourceName,
				P.Amount,
				P.CompanyName,
				P.StartDate,
				P.EndDate,
				P.LastUserNo,
				public."COMNGetUserName"(P.LastUserNo) AS LastUserName,
				P.Reason
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairscount.status)
			AND P.CompanyName ILIKE '%' || SearchText || '%'
		) A 
	END
	ELSE IF SearchMode = 3 -- 수리입고일 검색인 경우
	BEGIN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT	
				ROW_NUMBER() OVER(ORDER BY P.RepairNo Desc) As RowNum,
				P.RepairNo,
				P.ResourceNo,
				C.Name AS CategoryName,
				R.Name AS ResourceName,
				P.Amount,
				P.CompanyName,
				P.StartDate,
				P.EndDate,
				P.LastUserNo,
				public."COMNGetUserName"(P.LastUserNo) AS LastUserName,
				P.Reason
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairscount.status)
			AND P.StartDate BETWEEN CONVERT(DATE,SearchText) AND CONVERT(DATE,SearchText2)
		) A 
	END
	ELSE IF SearchMode = 4 -- 마지막 사용자인 경우
	BEGIN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT	
				ROW_NUMBER() OVER(ORDER BY P.RepairNo Desc) As RowNum,
				P.RepairNo,
				P.ResourceNo,
				C.Name AS CategoryName,
				R.Name AS ResourceName,
				P.Amount,
				P.CompanyName,
				P.StartDate,
				P.EndDate,
				P.LastUserNo,
				public."COMNGetUserName"(P.LastUserNo) AS LastUserName,
				P.Reason
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairscount.status)
			AND public."COMNGetUserName"(P.LastUserNo) ILIKE '%' || SearchText || '%'
		) A 
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
