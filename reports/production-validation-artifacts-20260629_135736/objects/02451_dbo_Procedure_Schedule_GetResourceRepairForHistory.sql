-- ─── PROCEDURE→FUNCTION: schedule_getresourcerepairforhistory ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcerepairforhistory();
CREATE OR REPLACE FUNCTION public.schedule_getresourcerepairforhistory(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		R.RepairNo,
		R.LastUserNo,
		public."COMNGetUserName"(R.LastUserNo) AS LastUserName,
		R.StartDate,
		R.CompanyName,
		R.Reason,
		R.RegUserNo,
		public."COMNGetUserName"(R.RegUserNo) As RegUserName
	FROM ScheduleResourcesRepair R
	WHERE R.ResourceNo = ResourceNo
	ORDER BY R.StartDate Desc;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
