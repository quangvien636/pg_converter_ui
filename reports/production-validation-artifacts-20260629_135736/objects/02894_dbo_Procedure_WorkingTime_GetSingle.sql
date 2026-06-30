-- ─── PROCEDURE→FUNCTION: workingtime_getsingle ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getsingle(integer, integer);
CREATE OR REPLACE FUNCTION public.workingtime_getsingle(
    IN workingno integer,
    IN reguserno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
