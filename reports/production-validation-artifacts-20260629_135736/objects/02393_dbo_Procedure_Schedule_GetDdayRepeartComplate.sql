-- ─── PROCEDURE→FUNCTION: schedule_getddayrepeartcomplate ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.schedule_getddayrepeartcomplate(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getddayrepeartcomplate(
    IN repeatdate timestamp without time zone
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT DdayNo
      ,RepeatDate
      ,CompleteDate
      ,IsComplete
	FROM public."ScheduleDdaysRepeat"
	WHERE DdayNo = DdayNo AND RepeatDate = schedule_getddayrepeartcomplate.repeatdate AND IsComplete = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
