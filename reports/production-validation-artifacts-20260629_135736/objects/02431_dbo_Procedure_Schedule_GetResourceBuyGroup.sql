-- ─── PROCEDURE→FUNCTION: schedule_getresourcebuygroup ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcebuygroup();
CREATE OR REPLACE FUNCTION public.schedule_getresourcebuygroup(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT
		BuyGroupNo,
		CompanyName,
		BuyDate,
		BuyQty,
		BuyAmount,
		MainManagerNo,
		public."COMNGetUserName"(MainManagerNo) AS MainManagerName,
		SubManagerNo,
		public."COMNGetUserName"(SubManagerNo) AS SubManagerName
	FROM ScheduleResourcesBuyGroup
	WHERE BuyGroupNo = BuyGroupNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
