-- ─── PROCEDURE→FUNCTION: schedule_getresourcedisposedetail ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcedisposedetail(boolean);
CREATE OR REPLACE FUNCTION public.schedule_getresourcedisposedetail(
    IN buygroupyn boolean DEFAULT FALSE
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	IF BuyGroupYN = 0 THEN
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
	END IF;
	ELSE

		
		SELECT BuyGroupNo INTO buygroupno FROM ScheduleResources
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
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
