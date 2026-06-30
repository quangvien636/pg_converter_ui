-- ─── FUNCTION: workingtime_getlasttimetype ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getlasttimetype(integer);
CREATE OR REPLACE FUNCTION public.workingtime_getlasttimetype(
    userno integer
) RETURNS TABLE(
    col1 text
)
-- TODO: DATEADD was not fully converted; use interval arithmetic
AS $function$
DECLARE
    timetype integer;
    timeoffset integer;
    workingtime timestamp without time zone;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN





  SELECT TimeType = TimeType, WorkingTime = public."AddWorkingDayTimes"(TimeOffset, WorkingDay, CheckTime), TimeOffset = TimeOffset
  FROM WorkingTime_Times
  WHERE WorkingNo = (SELECT max(WorkingNo) FROM WorkingTime_Times WHERE UserNo = workingtime_getlasttimetype.userno AND Provider in (1,2,3,4,9,10) and COALESCE(status,0) != 1)

  SET WorkingTime = DATEADD(HOUR,-TimeOffset, DATEADD(HOUR, 32, WorkingTime))

  IF WorkingTime > GETUTCDATE() 
	RETURN QUERY
	SELECT TimeType as TimeType
  ELSE
  BEGIN
	SET TimeType = 0
	RETURN QUERY
	SELECT TimeType as TimeType
  END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
