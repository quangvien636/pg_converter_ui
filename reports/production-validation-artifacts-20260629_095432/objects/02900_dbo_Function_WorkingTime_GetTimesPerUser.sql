-- ─── FUNCTION: workingtime_gettimesperuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_gettimesperuser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimesperuser(
    userno integer,
    startday integer,
    endday integer
) RETURNS TABLE(
    workingno text,
    workingday text,
    timetype text,
    checktime text,
    timechecklong text,
    provider text,
    latitude text,
    longitude text,
    remark text,
    timeoffset text,
    latcompany text,
    lngcompany text,
    distance text,
    beaconinfo text,
    distancecar text,
    col16 text,
    col17 text,
    groupid text,
    lunchstart text,
    lunchend text,
    col21 text,
    endworking text,
    isaddlunch text,
    bin1 text,
    bout1 text,
    bin2 text,
    bout2 text,
    isb1 text,
    isb2 text,
    col30 text,
    col31 text,
    col32 text,
    col33 text
)
AS $function$
BEGIN

	RETURN QUERY
	SELECT T.WorkingNo, T.WorkingDay, T.TimeType, T.CheckTime,T.TimeCheckLong,
		T.Provider, T.Latitude, T.Longitude, T.Remark, T.TimeOffset, T.LatCompany, T.LngCompany, T.Distance, T.BeaconInfo,
		COALESCE(D.Distance, 0) AS DistanceCar, IpServer = CASE WHEN STRPOS(IpServer, ':') > 1 THEN LEFT(IpServer,STRPOS(IpServer, ':')-1) ELSE IpServer END
		,COALESCE(COALESCE(NameCompany,O.Name),L.NAME) NameCompany
		,T.GroupId, T.LunchStart, T.LunchEnd, COALESCE(T.StarWorking,'0800') StarWorking, T.EndWorking, T.IsAddLunch
		,T.BIn1
		,T.BOut1
		,T.BIn2
		,T.BOut2
		,T.IsB1
		,T.IsB2
		,COALESCE(COALESCE(L.ErrorRange,O.ErrorRange),500) ErrorRange
		,COALESCE(RQ.Status,1) Status
		,COALESCE(RQ.Reject,0) Reject
		,COALESCE(RQ.RejectDes,'') RejectDes
	FROM WorkingTime_Times  T
	LEFT JOIN WorkingTime_DisplayPaths  D ON D.EndWorkingNo = T.WorkingNo
	LEFT JOIN WorkingTime_LocationsOutside O ON T.LocationNo = O.LocationNo AND T.TIMETYPE IN (2,4)
	LEFT JOIN WorkingTime_Locations L ON T.LocationNo = L.LocationNo AND T.TIMETYPE IN(1,3)
	LEFT JOIN WorkingTime_RequestCorrectionTime RQ ON T.WorkingNo = RQ.WorkingNo
	WHERE UserNo = workingtime_gettimesperuser.userno AND WorkingDay BETWEEN StartDay AND EndDay
	and COALESCE(t.status,0) != 1
	ORDER BY t.CheckTimeFull ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
