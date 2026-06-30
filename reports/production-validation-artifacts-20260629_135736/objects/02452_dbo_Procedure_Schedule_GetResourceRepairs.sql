-- ─── PROCEDURE→FUNCTION: schedule_getresourcerepairs ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairs(integer, integer, integer, character varying, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairs(
    IN pagesize integer DEFAULT 10,
    IN currpage integer DEFAULT 1,
    IN searchmode integer DEFAULT 0,
    IN searchtext2 character varying DEFAULT '',
    IN status character varying DEFAULT 'A' -- A:전체/R:접수중/I:업체수리중/F:수리완료
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SeachMode = 0 검색이 아닌경우
	IF SearchMode = 0 THEN
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
	END IF;
	ELSIF SearchMode = 1 -- 자원명 검색인 경우 THEN
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
	END IF;
	ELSIF SearchMode = 2 -- 수리업체 검색인 경우 THEN
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
	END IF;
	ELSIF SearchMode = 3 -- 수리입고일 검색인 경우 THEN
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
	END IF;
	ELSIF SearchMode = 4 -- 마지막 사용자인 경우 THEN
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
