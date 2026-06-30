-- ─── FUNCTION: workingtime_getsingle ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_getsingle(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsingle(
    workingno integer,
    reguserno integer
) RETURNS TABLE(
    workingno text,
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
    col12 text,
    timechecklong text,
    timeoffset text,
    distance text,
    latcompany text,
    lngcompany text,
    beaconinfo text,
    namecompany text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT WorkingNo, RegUserNo, RegDate, UserNo, WorkingDay, TimeType, CheckTime, Provider, Latitude, Longitude, Remark,
		IpServer = CASE WHEN STRPOS(IpServer, ':') > 1 THEN LEFT(IpServer,STRPOS(IpServer, ':')-1) ELSE IpServer END
		, TimeCheckLong, TimeOffset, Distance, LatCompany, LngCompany, BeaconInfo, address as NameCompany 
	FROM WorkingTime_Times
	WHERE WorkingNo = workingtime_getsingle.workingno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
