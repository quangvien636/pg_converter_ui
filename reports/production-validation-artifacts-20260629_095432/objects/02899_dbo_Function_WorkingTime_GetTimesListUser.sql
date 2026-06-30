-- ─── FUNCTION: workingtime_gettimeslistuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_gettimeslistuser(character varying, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimeslistuser(
    userlist character varying,
    startday integer,
    endday integer
) RETURNS TABLE(
    value text
)
AS $function$
BEGIN

	
	RETURN QUERY
	SELECT T.UserNo, T.WorkingNo, T.WorkingDay, T.TimeType, T.CheckTime,
		T.Provider, T.Latitude, T.Longitude, T.Remark, T.TimeOffset, T.LatCompany, T.LngCompany, T.Distance, T.BeaconInfo,
		COALESCE(D.Distance, 0) AS DistanceCar, IpServer = CASE WHEN STRPOS(IpServer, ':') > 1 THEN LEFT(IpServer,STRPOS(IpServer, ':')-1) ELSE IpServer END
		,COALESCE(COALESCE(T.NameCompany,O.Name),L.NAME) NameCompany
		,COALESCE(T.StarWorking,'0800') StarWorking
		,COALESCE(COALESCE(L.ErrorRange,O.ErrorRange),500) ErrorRange
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
	FROM WorkingTime_Times T
	LEFT JOIN WorkingTime_DisplayPaths D ON D.EndWorkingNo = T.WorkingNo
	INNER JOIN (SELECT VALUE FROM public."UF_TEXT_SPLIT"(UserList,',')) U ON U.VALUE=T.UserNo
	LEFT JOIN WorkingTime_LocationsOutside O ON T.LocationNo = O.LocationNo AND T.TIMETYPE IN (2,4)
	LEFT JOIN WorkingTime_Locations L ON T.LocationNo = L.LocationNo AND T.TIMETYPE NOT IN(2,4)
	LEFT JOIN WorkingTime_RequestCorrectionTime RQ ON T.WorkingNo = RQ.WorkingNo
	WHERE WorkingDay BETWEEN StartDay AND EndDay
	and COALESCE(t.status,0) != 1
	ORDER BY CheckTimeFull,T.WorkingDay , CheckTime, WorkingNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
