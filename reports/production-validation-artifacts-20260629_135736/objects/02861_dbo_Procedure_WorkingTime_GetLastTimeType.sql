-- ─── PROCEDURE→FUNCTION: workingtime_getlasttimetype ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: DATEADD was not fully converted; use interval arithmetic
DROP FUNCTION IF EXISTS public.workingtime_getlasttimetype(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlasttimetype(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    timetype integer;
    timeoffset integer;
    workingtime timestamp without time zone;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





  TimeType := (TimeType, WorkingTime = public."AddWorkingDayTimes"(TimeOffset, WorkingDay, CheckTime), TimeOffset = TimeOffset);
  FROM WorkingTime_Times
  WHERE WorkingNo = (SELECT max(WorkingNo) FROM WorkingTime_Times WHERE UserNo = workingtime_getlasttimetype.userno AND Provider in (1,2,3,4,9,10) and COALESCE(status,0) != 1)

  WorkingTime := DATEADD(HOUR,-TimeOffset, DATEADD(HOUR, 32, WorkingTime));
  IF WorkingTime > GETUTCDATE() THEN
	RETURN QUERY
	SELECT TimeType as TimeType
  ELSE
	TimeType := 0;
	RETURN QUERY
	SELECT TimeType as TimeType
  END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
