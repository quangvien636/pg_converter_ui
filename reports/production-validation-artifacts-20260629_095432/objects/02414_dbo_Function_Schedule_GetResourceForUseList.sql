-- ─── FUNCTION: schedule_getresourceforuselist ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourceforuselist(integer, integer, character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourceforuselist(
    categoryno integer DEFAULT 0,
    searchmode integer DEFAULT 0,
    searchtext character varying DEFAULT '',
    pagesize integer DEFAULT 10,
    currpage integer DEFAULT 1
) RETURNS TABLE(
    resourceno text,
    usecount text
)
AS $function$
BEGIN


	IF SearchMode = 0
	BEGIN

		RETURN QUERY
		SELECT
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY BuyGroupNo) AS RowNum,
				*
			FROM (
				SELECT DISTINCT B.BuyGroupNo,
					R.Name,
					B.BuyQty,
					COALESCE(SUM(U.UseCount),0) AS UseCount,
					CASE WHEN B.BuyQty - COALESCE(SUM(U.UseCount),0) < 0 THEN 0 ELSE B.BuyQty - COALESCE(SUM(U.UseCount),0) END  AS UnUseCount
				FROM ScheduleResourcesBuyGroup B
				INNER JOIN (
					SELECT
						ResourceNo, BuyGroupNo, Name
					FROM ScheduleResources
					WHERE Enabled = TRUE
					AND (CategoryNo = 0 OR CategoryNo = schedule_getresourceforuselist.categoryno)
				) R ON R.BuyGroupNo = B.BuyGroupNo
				LEFT JOIN (
					SELECT ResourceNo, COUNT(ResourceNo) AS UseCount
					FROM ScheduleResourceReservations
					WHERE SelDate BETWEEN StartDate AND EndDate
					GROUP BY ResourceNo
				) U ON U.ResourceNo = R.ResourceNo 
				GROUP BY B.BuyGroupNo, R.Name, B.BuyQty
			) AA
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END
	ELSE IF SearchMode = 1 -- 자원명검색
	BEGIN
		RETURN QUERY
		SELECT
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY BuyGroupNo) AS RowNum,
				*
			FROM (
				SELECT DISTINCT B.BuyGroupNo,
					R.Name,
					B.BuyQty,
					COALESCE(SUM(U.UseCount),0) AS UseCount,
					CASE WHEN B.BuyQty - COALESCE(SUM(U.UseCount),0) < 0 THEN 0 ELSE B.BuyQty - COALESCE(SUM(U.UseCount),0) END AS UnUseCount
				FROM ScheduleResourcesBuyGroup B
				INNER JOIN (
					SELECT
						ResourceNo, BuyGroupNo, Name
					FROM ScheduleResources
					WHERE Enabled = TRUE
					AND (CategoryNo = 0 OR CategoryNo = schedule_getresourceforuselist.categoryno)
					AND  Name ILIKE '%' || SearchText || '%' 
				) R ON R.BuyGroupNo = B.BuyGroupNo
				LEFT JOIN (
					SELECT ResourceNo, COUNT(ResourceNo) AS UseCount
					FROM ScheduleResourceReservations
					WHERE SelDate BETWEEN StartDate AND EndDate
					GROUP BY ResourceNo
				) U ON U.ResourceNo = R.ResourceNo 
				GROUP BY B.BuyGroupNo, R.Name, B.BuyQty
			) AA
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END	
	ELSE IF SearchMode = 2 -- 사용자명
	BEGIN

		RETURN QUERY
		SELECT
			*
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY BuyGroupNo) AS RowNum,
				*
			FROM (
				SELECT DISTINCT B.BuyGroupNo,
					R.Name,
					B.BuyQty,
					COALESCE(SUM(U.UseCount),0) AS UseCount,
					CASE WHEN B.BuyQty - COALESCE(SUM(U.UseCount),0) < 0 THEN 0 ELSE B.BuyQty - COALESCE(SUM(U.UseCount),0) END  AS UnUseCount
				FROM ScheduleResourcesBuyGroup B
				INNER JOIN (
					SELECT
						ResourceNo, BuyGroupNo, Name
					FROM ScheduleResources
					WHERE Enabled = TRUE
					AND (CategoryNo = 0 OR CategoryNo = schedule_getresourceforuselist.categoryno) 
				) R ON R.BuyGroupNo = B.BuyGroupNo
				LEFT JOIN (
					SELECT ResourceNo, COUNT(ResourceNo) AS UseCount
					FROM ScheduleResourceReservations
					WHERE SelDate BETWEEN StartDate AND EndDate
					AND public."COMNGetUserName"(RegUserNo) ILIKE '%' || SearchText || '%'
					GROUP BY ResourceNo
				) U ON U.ResourceNo = R.ResourceNo 
				GROUP BY B.BuyGroupNo, R.Name, B.BuyQty
			) AA
		) A
		WHERE RowNum  BETWEEN ((CurrPage-1) * PageSize + 1) AND (CurrPage * PageSize)  
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
