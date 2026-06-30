-- ─── PROCEDURE→FUNCTION: schedule_getresourcesforcategorycount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcesforcategorycount(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcesforcategorycount(
    IN enabled boolean
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	IF Enabled = TRUE THEN
		RETURN QUERY
		SELECT COUNT(*) AS CNT
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY R.ResourceNo ASC) AS RowNum,
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
	END IF;
	ELSE
		RETURN QUERY
		SELECT COUNT(*) AS CNT
		FROM
		(
			SELECT
				ROW_NUMBER() OVER(ORDER BY R.ResourceNo ASC) AS RowNum,
				R.ResourceNo,
				C.Name AS CategoryName,
				R.Name As ResourceName,
				R.Enabled,
				CASE WHEN R.Enabled = TRUE THEN '사용' ELSE '미사용' END AS UseYN
			FROM ScheduleResources R
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			WHERE (0 = CategoryNo OR R.CategoryNo = CategoryNo)
		) A
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
