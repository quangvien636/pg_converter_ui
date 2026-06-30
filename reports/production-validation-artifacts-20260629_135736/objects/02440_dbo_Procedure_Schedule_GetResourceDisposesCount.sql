-- ─── PROCEDURE→FUNCTION: schedule_getresourcedisposescount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcedisposescount(integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcedisposescount(
    IN searchmode integer DEFAULT 0,
    IN searchtext2 character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF SearchMode = 0 -- 전체 검색 THEN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY D.DisposeNo Desc) As RowNum,
				D.DisposeNo,
				D.ResourceNo,
				C.Name As CategoryName,
				R.Name AS ResourceName,
				G.CompanyName,
				D.DisposeDate,
				D.DisposeReason
			FROM ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON G.BuyGroupNo = R.BuyGroupNo
			WHERE (CategoryNo = 0 OR C.CategoryNo = CategoryNo)
			AND (
				R.Name ILIKE '%' || SearchText || '%' OR
				G.CompanyName ILIKE '%' || SearchText || '%'
			)
		) A
	END IF;
	ELSIF SearchMode = 1 -- 자원 THEN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY D.DisposeNo Desc) As RowNum,
				D.DisposeNo,
				D.ResourceNo,
				C.Name As CategoryName,
				R.Name AS ResourceName,
				G.CompanyName,
				D.DisposeDate,
				D.DisposeReason
			FROM ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON G.BuyGroupNo = R.BuyGroupNo
			WHERE (CategoryNo = 0 OR C.CategoryNo = CategoryNo)
			AND R.Name ILIKE '%' || SearchText || '%'
		) A
	
	END IF;
	ELSIF SearchMode = 1 -- 구입업체 THEN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY D.DisposeNo Desc) As RowNum,
				D.DisposeNo,
				D.ResourceNo,
				C.Name As CategoryName,
				R.Name AS ResourceName,
				G.CompanyName,
				D.DisposeDate,
				D.DisposeReason
			FROM ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON G.BuyGroupNo = R.BuyGroupNo
			WHERE (CategoryNo = 0 OR C.CategoryNo = CategoryNo)
			AND R.Name ILIKE '%' || SearchText || '%'
		) A
		
	END IF;
	ELSIF SearchMode = 2 -- 자원 THEN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY D.DisposeNo Desc) As RowNum,
				D.DisposeNo,
				D.ResourceNo,
				C.Name As CategoryName,
				R.Name AS ResourceName,
				G.CompanyName,
				D.DisposeDate,
				D.DisposeReason
			FROM ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON G.BuyGroupNo = R.BuyGroupNo
			WHERE (CategoryNo = 0 OR C.CategoryNo = CategoryNo)
			AND G.CompanyName ILIKE '%' || SearchText || '%'
		) A
		
	END IF;
	ELSIF SearchMode = 3 -- 폐기일 THEN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY D.DisposeNo Desc) As RowNum,
				D.DisposeNo,
				D.ResourceNo,
				C.Name As CategoryName,
				R.Name AS ResourceName,
				G.CompanyName,
				D.DisposeDate,
				D.DisposeReason
			FROM ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON G.BuyGroupNo = R.BuyGroupNo
			WHERE (CategoryNo = 0 OR C.CategoryNo = CategoryNo)
			AND D.DisposeDate BETWEEN CONVERT(DATE,SearchText) AND CONVERT(DATE,SearchText2)
		) A
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
