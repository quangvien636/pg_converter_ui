-- ─── FUNCTION: schedule_getresourcedisposescount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcedisposescount(integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourcedisposescount(
    searchmode integer DEFAULT 0,
    searchtext2 character varying DEFAULT ''
) RETURNS TABLE(
    rownum text,
    disposeno text,
    resourceno text,
    categoryname text,
    resourcename text,
    companyname text,
    disposedate text,
    disposereason text
)
AS $function$
BEGIN

	IF SearchMode = 0 -- 전체 검색
	BEGIN
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
	END
	ELSE IF SearchMode = 1 -- 자원
	BEGIN
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
	
	END
	ELSE IF SearchMode = 1 -- 구입업체
	BEGIN
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
		
	END
	ELSE IF SearchMode = 2 -- 자원
	BEGIN
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
		
	END
	ELSE IF SearchMode = 3 -- 폐기일
	BEGIN
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
