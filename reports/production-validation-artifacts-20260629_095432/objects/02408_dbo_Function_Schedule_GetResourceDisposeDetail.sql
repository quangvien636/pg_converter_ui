-- ─── FUNCTION: schedule_getresourcedisposedetail ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_getresourcedisposedetail(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcedisposedetail(
    buygroupyn boolean DEFAULT FALSE
) RETURNS TABLE(
    disposeno text,
    resourceno text,
    resourcename text,
    categoryname text,
    companyname text,
    disposedate text,
    disposereason text
)
AS $function$
BEGIN

	IF BuyGroupYN = 0
	BEGIN
		RETURN QUERY
		SELECT
			D.DisposeNo,
			D.ResourceNo,
			R.Name AS ResourceName,
			C.Name AS CategoryName,
			G.CompanyName,
			D.DisposeDate,
			D.DisposeReason
		FROM
			ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON R.BuyGroupNo = G.BuyGroupNo
		WHERE D.DisposeNo = DisposeNo	
	END 
	ELSE 
	BEGIN

		
		SELECT BuyGroupNo = BuyGroupNo FROM ScheduleResources
		WHERE ResourceNo = (
			SELECT ResourceNo 
			FROM ScheduleResourcesDispose
			WHERE DisposeNo = DisposeNo
			)
		RETURN QUERY
		SELECT
			D.DisposeNo,
			D.ResourceNo,
			R.Name AS ResourceName,
			C.Name AS CategoryName,
			G.CompanyName,
			D.DisposeDate,
			D.DisposeReason
		FROM
			ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON R.BuyGroupNo = G.BuyGroupNo
		WHERE D.DisposeNo = DisposeNo
		UNION ALL
		RETURN QUERY
		SELECT
			D.DisposeNo,
			D.ResourceNo,
			R.Name AS ResourceName,
			C.Name AS CategoryName,
			G.CompanyName,
			D.DisposeDate,
			D.DisposeReason
		FROM
			ScheduleResourcesDispose D
			LEFT JOIN ScheduleResources R ON R.ResourceNo = D.ResourceNo
			LEFT JOIN ScheduleResourceCategories C ON C.CategoryNo = R.CategoryNo
			LEFT JOIN ScheduleResourcesBuyGroup G ON R.BuyGroupNo = G.BuyGroupNo
		WHERE R.BuyGroupNo = BuyGroupNo
		AND D.DisposeNo <> DisposeNo
	END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
