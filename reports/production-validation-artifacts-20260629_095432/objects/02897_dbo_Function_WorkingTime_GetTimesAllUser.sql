-- ─── FUNCTION: workingtime_gettimesalluser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_gettimesalluser(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimesalluser(
    startday integer,
    endday integer
) RETURNS TABLE(
    userno text,
    workingno text,
    workingday text,
    timetype text,
    checktime text,
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
    col18 text,
    col19 text,
    col20 text,
    col21 text,
    col22 text,
    timeworking text,
    col24 text,
    checktimec text,
    checktimefull text,
    timeworking2 text,
    col28 text,
    col29 text,
    col30 text,
    col31 text,
    isaddlunch text,
    lunchstart text,
    lunchend text,
    bin1 text,
    bout1 text,
    bin2 text,
    bout2 text,
    isb1 text,
    isb2 text,
    groupid text,
    timechecklong text
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT T.UserNo, T.WorkingNo, T.WorkingDay, T.TimeType, T.CheckTime,
		T.Provider, T.Latitude, T.Longitude, T.Remark, T.TimeOffset, T.LatCompany, T.LngCompany, T.Distance, T.BeaconInfo,
		COALESCE(D.Distance, 0) AS DistanceCar, IpServer = CASE WHEN STRPOS(IpServer, ':') > 1 THEN LEFT(IpServer,STRPOS(IpServer, ':')-1) ELSE IpServer END
		,COALESCE(COALESCE(O.Name, T.NameCompany),L.NAME) NameCompany --20251013
		,COALESCE(COALESCE(L.ErrorRange,O.ErrorRange),500) ErrorRange
		,COALESCE(T.StarWorking,'0800') StarWorking
		,COALESCE(RQ.Status,1) Status
		,COALESCE(RQ.Reject,0) Reject
		,COALESCE(RQ.RejectDes,'') RejectDes
		,T.TimeWorking
		,COALESCE(T.WorkingDayC,T.WorkingDay) WorkingDayC
		,T.CheckTimeC
		,T.CheckTimeFull
		,T.TimeWorking2
		,COALESCE(COALESCE(T.Address,COALESCE(O.NAME,L.NAME)),'') Descriptions
		,COALESCE(t.bname,'') bname
		,COALESCE(t.bno,0) bno
		, T.EndWorking ---20231102
		, T.IsAddLunch 
		, T.LunchStart
		, T.LunchEnd
		,T.BIn1
		,T.BOut1
		,T.BIn2
		,T.BOut2
		,T.IsB1
		,T.IsB2
		,T.GroupId
		,T.TimeCheckLong
	FROM WorkingTime_Times T
	LEFT JOIN WorkingTime_DisplayPaths D ON D.EndWorkingNo = T.WorkingNo
	LEFT JOIN WorkingTime_LocationsOutside O ON T.LocationNo = O.LocationNo AND T.TIMETYPE IN (2,4)
	LEFT JOIN WorkingTime_Locations L ON T.LocationNo = L.LocationNo AND T.TIMETYPE NOT IN(2,4)
	LEFT JOIN WorkingTime_RequestCorrectionTime RQ ON T.WorkingNo = RQ.WorkingNo
	WHERE WorkingDayC BETWEEN StartDay AND EndDay
	and COALESCE(t.status,0) != 1
	ORDER BY t.CheckTimeFull ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
