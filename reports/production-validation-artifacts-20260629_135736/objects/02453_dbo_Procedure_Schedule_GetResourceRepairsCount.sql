-- ─── PROCEDURE→FUNCTION: schedule_getresourcerepairscount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairscount(integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairscount(
    IN searchmode integer DEFAULT 0,
    IN searchtext2 character varying DEFAULT '',
    IN status character varying DEFAULT 'A'
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SeachMode = 0 검색이 아닌경우
	IF SearchMode = 0 THEN
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
	END IF;
	ELSIF SearchMode = 1 -- 자원명 검색인 경우 THEN
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
	END IF;
	ELSIF SearchMode = 2 -- 수리업체 검색인 경우 THEN
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
	END IF;
	ELSIF SearchMode = 3 -- 수리입고일 검색인 경우 THEN
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
	END IF;
	ELSIF SearchMode = 4 -- 마지막 사용자인 경우 THEN
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
