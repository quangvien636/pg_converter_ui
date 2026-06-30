-- ─── FUNCTION: workingtime_timeworkforuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_timeworkforuser(integer);
CREATE OR REPLACE FUNCTION public.workingtime_timeworkforuser(
    userno integer
) RETURNS TABLE(
    workingtime text
)
AS $function$
BEGIN

	 RETURN QUERY
	 SELECT  public."WorkingTime_TimeWorkForUser_Funtion_v2"(UserNo, WorkingDay) AS WorkingTime;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
