-- ─── FUNCTION: workingtime_getprevioustime ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getprevioustime(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getprevioustime(
    reguserno integer,
    workingday integer,
    workingno integer
) RETURNS TABLE(
    col1 text,
    reguserno text,
    regdate text,
    userno text,
    workingday text,
    timetype text,
    checktime text,
    provider text,
    latitude text,
    longitude text,
    remark text,
    ipserver text,
    timechecklong text,
    timeoffset text,
    distance text,
    latcompany text,
    lngcompany text,
    beaconinfo text,
    namecompany text
)
-- TODO: TOP was preserved as comment; add LIMIT manually
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT /* TOP 1 */ WorkingNo, RegUserNo, RegDate, UserNo, WorkingDay, TimeType, CheckTime, Provider,
		Latitude, Longitude, Remark, IpServer, TimeCheckLong, TimeOffset, Distance, LatCompany,
		LngCompany, BeaconInfo, NameCompany
	FROM WorkingTime_Times T
	WHERE T.RegUserNo = workingtime_getprevioustime.reguserno AND WorkingDay = workingtime_getprevioustime.workingday AND WorkingNo < workingtime_getprevioustime.workingno
	and COALESCE(t.status,0) != 1
	ORDER BY WorkingNo DESC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
