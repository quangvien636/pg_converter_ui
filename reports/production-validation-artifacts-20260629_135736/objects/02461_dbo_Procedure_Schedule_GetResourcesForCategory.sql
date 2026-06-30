-- ─── PROCEDURE→FUNCTION: schedule_getresourcesforcategory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcesforcategory(boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourcesforcategory(
    IN enabled boolean,
    IN page_size integer DEFAULT 10,
    IN curr_page integer DEFAULT 1
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Enabled = TRUE THEN
		RETURN QUERY
		SELECT *
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY R.ResourceNo DESC) AS RowNum,
				R.ResourceNo,
				C.Name AS CategoryName,
				R.Name As ResourceName,
				R.Enabled,
				CASE WHEN R.Enabled = TRUE THEN '사용' ELSE '미사용' END AS UseYN
			FROM ScheduleResources R
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			WHERE (0 = CategoryNo OR R.CategoryNo = CategoryNo)
			AND R.Enabled = TRUE
		) A
		WHERE RowNum BETWEEN ((CURR_PAGE-1) * PAGE_SIZE + 1) AND (CURR_PAGE * PAGE_SIZE)  
	END IF;
	ELSE
		RETURN QUERY
		SELECT *
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY R.ResourceNo DESC) AS RowNum,
				R.ResourceNo,
				C.Name AS CategoryName,
				R.Name As ResourceName,
				R.Enabled,
				CASE WHEN R.Enabled = TRUE THEN '사용' ELSE '미사용' END AS UseYN
			FROM ScheduleResources R
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			WHERE (0 = CategoryNo OR R.CategoryNo = CategoryNo)
		) A
		WHERE RowNum BETWEEN ((CURR_PAGE-1) * PAGE_SIZE + 1) AND (CURR_PAGE * PAGE_SIZE)  
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
