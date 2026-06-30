-- ─── FUNCTION: workingtime_setworkingtime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_setworkingtime(integer, integer, integer, integer, character varying, integer, double precision, double precision, character varying, double precision, double precision);
CREATE OR REPLACE FUNCTION public.workingtime_setworkingtime(
    reguserno integer,
    userno integer,
    workingday integer,
    timetype integer,
    checktime character varying,
    provider integer,
    latitude double precision,
    longitude double precision,
    remark character varying,
    longtime double precision,
    timeoffset double precision
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkingTime_Times(RegUserNo, RegDate, UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,TimeCheckLong,TimeOffset)
	VALUES(RegUserNo, NOW(), UserNo, WorkingDay, TimeType,
		CheckTime, Provider, Latitude, Longitude, Remark,LongTime,TimeOffset);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
