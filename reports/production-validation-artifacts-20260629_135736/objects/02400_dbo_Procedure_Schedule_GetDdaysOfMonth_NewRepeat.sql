-- ─── PROCEDURE→FUNCTION: schedule_getddaysofmonth_newrepeat ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.schedule_getddaysofmonth_newrepeat(timestamp without time zone);
CREATE OR REPLACE FUNCTION public.schedule_getddaysofmonth_newrepeat(
    IN curentdate timestamp without time zone
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
  WHERE  DdayNo = DdayNo AND RepeatDate >= DATEADD(MONTH, DATEDIFF(MONTH, 0, CurentDate), 0) AND RepeatDate <= DATEADD(MONTH, DATEDIFF(MONTH, -1, CurentDate), -1);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
