-- ─── FUNCTION: workingtime_employeeon ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_employeeon(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_employeeon(
    p_from integer,
    p_to integer,
    p_uid integer
) RETURNS TABLE(
    calculaterno serial,
    userno integer,
    workingday integer,
    timecheckin double precision,
    timecheckout double precision,
    regdate timestamp without time zone,
    timework double precision,
    type integer,
    workingnoref integer,
    timelate integer,
    timeofset double precision,
    checkin timestamp without time zone,
    checkout timestamp without time zone,
    status integer,
    typeout integer,
    ischeckin integer,
    ischeckout integer,
    statusout integer
)
AS $function$
BEGIN


	RETURN QUERY
	select * from WorkingTime_Calculater c 
	where c.UserNo = workingtime_employeeon.p_uid and c.WorkingDay between p_From and p_To;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
