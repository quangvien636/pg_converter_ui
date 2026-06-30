-- ─── PROCEDURE→FUNCTION: workingtime_gettimesperuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_gettimesperuser(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_gettimesperuser(
    IN userno integer,
    IN startday integer,
    IN endday integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
