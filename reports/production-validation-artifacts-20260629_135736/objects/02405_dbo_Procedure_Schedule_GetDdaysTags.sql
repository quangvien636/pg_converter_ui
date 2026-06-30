-- ─── PROCEDURE→FUNCTION: schedule_getddaystags ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddaystags();
CREATE OR REPLACE FUNCTION public.schedule_getddaystags(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT T.UserNo, T.GroupNo, CASE WHEN T.GroupNo = 0 THEN '미지정' ELSE G.Name END As GroupName, T.TagImageNo 
	FROM ScheduleDdaysTag T
	LEFT OUTER JOIN ScheduleDdayGroups G ON T.GroupNo = G.GroupNo
	WHERE UserNo = UserNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
