-- ─── PROCEDURE→FUNCTION: workingtime_getprevioustime ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.workingtime_getprevioustime(integer, integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getprevioustime(
    IN reguserno integer,
    IN workingday integer,
    IN workingno integer
) RETURNS SETOF record
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
