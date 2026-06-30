-- ─── FUNCTION: schedule_getresourceforuselistcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourceforuselistcount(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourceforuselistcount(
    categoryno integer DEFAULT 0,
    searchmode integer DEFAULT 0,
    searchtext character varying DEFAULT ''
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
			COUNT(*) AS CNT
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
					B.BuyQty - COALESCE(SUM(U.UseCount),0) AS UnUseCount
				FROM ScheduleResourcesBuyGroup B
				INNER JOIN (
					SELECT
						ResourceNo, BuyGroupNo, Name
					FROM ScheduleResources
					WHERE Enabled = TRUE
					AND (CategoryNo = 0 OR CategoryNo = schedule_getresourceforuselistcount.categoryno)
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
	END
	ELSE IF SearchMode = 1 -- 자원명검색
	BEGIN
		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
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
					B.BuyQty - COALESCE(SUM(U.UseCount),0) AS UnUseCount
				FROM ScheduleResourcesBuyGroup B
				INNER JOIN (
					SELECT
						ResourceNo, BuyGroupNo, Name
					FROM ScheduleResources
					WHERE Enabled = TRUE
					AND (CategoryNo = 0 OR CategoryNo = schedule_getresourceforuselistcount.categoryno)
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
	END	
	ELSE IF SearchMode = 2 -- 사용자명
	BEGIN

		RETURN QUERY
		SELECT
			COUNT(*) AS CNT
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
					B.BuyQty - COALESCE(SUM(U.UseCount),0) AS UnUseCount
				FROM ScheduleResourcesBuyGroup B
				INNER JOIN (
					SELECT
						ResourceNo, BuyGroupNo, Name
					FROM ScheduleResources
					WHERE Enabled = TRUE
					AND (CategoryNo = 0 OR CategoryNo = schedule_getresourceforuselistcount.categoryno) 
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
