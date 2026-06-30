-- ─── FUNCTION: schedule_getresourcesforcategorycount ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcesforcategorycount(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcesforcategorycount(
    enabled boolean
) RETURNS TABLE(
    rownum text,
    resourceno text,
    categoryname text,
    resourcename text,
    enabled text,
    useyn text
)
AS $function$
BEGIN


	IF Enabled = TRUE
	BEGIN
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
	END
	ELSE
	BEGIN
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
