-- ─── PROCEDURE→FUNCTION: schedule_getresourcesforbuygroupcount ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getresourcesforbuygroupcount();
CREATE OR REPLACE FUNCTION public.schedule_getresourcesforbuygroupcount(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
		COUNT(*) AS CNT
	FROM
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY ResourceNo ASC) AS RowNum,
			ResourceNo,
			Name,
			Description,
			CASE WHEN IsDisposed = TRUE THEN '폐기'
				 WHEN IsRepair = TRUE THEN '수리중'
				 WHEN Enabled = TRUE THEN '사용가능'
				 ELSE '사용불가'
			END AS Status
		FROM ScheduleResources
		WHERE BuyGroupNo = BuyGroupNo
	) A;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
