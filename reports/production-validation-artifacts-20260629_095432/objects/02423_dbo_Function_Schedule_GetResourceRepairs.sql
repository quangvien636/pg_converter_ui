-- ─── FUNCTION: schedule_getresourcerepairs ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairs(integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairs(
    pagesize integer DEFAULT 10,
    currpage integer DEFAULT 1,
    searchmode integer DEFAULT 0,
    searchtext2 character varying DEFAULT '',
    status character varying DEFAULT 'A' -- A:전체/R:접수중/I:업체수리중/F:수리완료
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
    reason text,
    status text,
    statusdesc text
)
AS $function$
BEGIN

	-- SeachMode = 0 검색이 아닌경우
	IF SearchMode = 0
	BEGIN
		RETURN QUERY
		SELECT
			*
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
				P.Reason,
				P.Status,
				CASE WHEN P.Status = 'R' THEN '접수중'
					 WHEN P.Status = 'I' THEN '수리중'
					 WHEN P.Status = 'F' THEN '수리완료'
				END AS StatusDesc
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairs.status)
			AND (
				R.Name ILIKE '%' || SearchText || '%' OR
			    P.CompanyName ILIKE '%' || SearchText || '%' OR
			    public."COMNGetUserName"(P.LastUserNo) ILIKE '%' || SearchText || '%' 
			)
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END
	ELSE IF SearchMode = 1 -- 자원명 검색인 경우
	BEGIN
		RETURN QUERY
		SELECT
			*
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
				P.Reason,
				P.Status,
				CASE WHEN P.Status = 'R' THEN '접수중'
					 WHEN P.Status = 'I' THEN '수리중'
					 WHEN P.Status = 'F' THEN '수리완료'
				END AS StatusDesc
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairs.status)
			AND R.Name ILIKE '%' || SearchText || '%'
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END
	ELSE IF SearchMode = 2 -- 수리업체 검색인 경우
	BEGIN
		RETURN QUERY
		SELECT
			*
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
				P.Reason,
				P.Status,
				CASE WHEN P.Status = 'R' THEN '접수중'
					 WHEN P.Status = 'I' THEN '수리중'
					 WHEN P.Status = 'F' THEN '수리완료'
				END AS StatusDesc
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairs.status)
			AND P.CompanyName ILIKE '%' || SearchText || '%'
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END
	ELSE IF SearchMode = 3 -- 수리입고일 검색인 경우
	BEGIN
		RETURN QUERY
		SELECT
			*
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
				P.Reason,
				P.Status,
				CASE WHEN P.Status = 'R' THEN '접수중'
					 WHEN P.Status = 'I' THEN '수리중'
					 WHEN P.Status = 'F' THEN '수리완료'
				END AS StatusDesc
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairs.status)
			AND P.StartDate BETWEEN CONVERT(DATE,SearchText) AND CONVERT(DATE,SearchText2)
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END
	ELSE IF SearchMode = 4 -- 마지막 사용자인 경우
	BEGIN
		RETURN QUERY
		SELECT
			*
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
				P.Reason,
				P.Status,
				CASE WHEN P.Status = 'R' THEN '접수중'
					 WHEN P.Status = 'I' THEN '업체수리중'
					 WHEN P.Status = 'F' THEN '수리완료'
				END AS StatusDesc
			FROM ScheduleResourcesRepair P 
			LEFT JOIN ScheduleResources R ON P.ResourceNo = R.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON R.CategoryNo = C.CategoryNo
			WHERE (CategoryNo = 0 OR R.CategoryNo = CategoryNo)
			AND (Status = 'A' OR P.Status = schedule_getresourcerepairs.status)
			AND public."COMNGetUserName"(P.LastUserNo) ILIKE '%' || SearchText || '%'
		) A
		WHERE RowNum BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
