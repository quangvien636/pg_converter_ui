-- ─── PROCEDURE→FUNCTION: schedule_getresourceforuselistcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourceforuselistcount(integer, integer, character varying);
CREATE OR REPLACE FUNCTION public.schedule_getresourceforuselistcount(
    IN categoryno integer DEFAULT 0,
    IN searchmode integer DEFAULT 0,
    IN searchtext character varying DEFAULT ''
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF SearchMode = 0 THEN

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
	END IF;
	ELSIF SearchMode = 1 -- 자원명검색 THEN
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
	END IF;
	ELSIF SearchMode = 2 -- 사용자명 THEN

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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
