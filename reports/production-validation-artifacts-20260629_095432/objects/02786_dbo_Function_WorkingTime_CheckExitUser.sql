-- ─── FUNCTION: workingtime_checkexituser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_checkexituser(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_checkexituser(
    workingday integer,
    userno integer
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
	SELECT *
	FROM WorkingTime_Calculater
	WHERE WorkingDay=workingtime_checkexituser.workingday AND UserNo=workingtime_checkexituser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
