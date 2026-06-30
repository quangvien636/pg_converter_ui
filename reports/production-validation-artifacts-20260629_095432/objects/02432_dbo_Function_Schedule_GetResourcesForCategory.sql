-- ─── FUNCTION: schedule_getresourcesforcategory ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcesforcategory(boolean, integer, integer);
CREATE OR REPLACE FUNCTION public.schedule_getresourcesforcategory(
    enabled boolean,
    page_size integer DEFAULT 10,
    curr_page integer DEFAULT 1
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
	END
	ELSE
	BEGIN
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
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
