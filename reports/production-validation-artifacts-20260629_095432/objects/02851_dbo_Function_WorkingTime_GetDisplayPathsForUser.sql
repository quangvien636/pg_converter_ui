-- ─── FUNCTION: workingtime_getdisplaypathsforuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getdisplaypathsforuser(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getdisplaypathsforuser(
    userno integer,
    workingday integer
) RETURNS TABLE(
    workingno text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT PathNo, StartWorkingNo, EndWorkingNo, Paths, Distance
	FROM WorkingTime_DisplayPaths
	WHERE EndWorkingNo IN (SELECT WorkingNo FROM WorkingTime_Times WHERE UserNo = workingtime_getdisplaypathsforuser.userno AND WorkingDay = workingtime_getdisplaypathsforuser.workingday)
	ORDER BY StartWorkingNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
