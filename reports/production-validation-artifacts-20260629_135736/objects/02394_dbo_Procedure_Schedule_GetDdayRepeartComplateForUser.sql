-- ─── PROCEDURE→FUNCTION: schedule_getddayrepeartcomplateforuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.schedule_getddayrepeartcomplateforuser();
CREATE OR REPLACE FUNCTION public.schedule_getddayrepeartcomplateforuser(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ DdayNo
      ,RepeatDate
      ,CompleteDate
      ,IsComplete
	FROM public."ScheduleDdaysRepeat"
	WHERE DdayNo = DdayNo AND IsComplete = 'Y';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
